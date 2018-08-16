//
//  SSFMDBManager.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SSFMDBManager.h"

@interface SSFMDBManager()

@property (nonatomic, strong) NSMutableArray <NSString *> *createTableStatements;

@end

@implementation SSFMDBManager
{//先删除没有用到的函数对应删除之前的commitId:c532df1c9e9fcf78e580b67ab1aaaffe7a7dead6
    FMDatabaseQueue *_databaseQueue;
}

- (NSMutableArray <NSString *>*)createTableStatements{
    if(!_createTableStatements){
        _createTableStatements = [NSMutableArray new];
    }
    return _createTableStatements;
}

- (void)setUpTables{
    
    //Home
    [[SSFMDBManager shareInstance] prepareTableStatement:@"tb_favorite"
                                                keyTypes:@{
                                                           @"username":@"text",
                                                           @"nickname":@"text primary key",
                                                           @"password":@"text",
                                                           @"website":@"text",
                                                           @"email":@"text",
                                                           @"category":@"text",
                                                           @"remark":@"text",
                                                           }];
    [[SSFMDBManager shareInstance] prepareTableStatement:@"tb_category"
                                                keyTypes:@{
                                                           @"category":@"text primary key",
                                                           }];
    //Search
    [[SSFMDBManager shareInstance] prepareTableStatement:@"tb_search"
                                                keyTypes:@{
                                                           @"username":@"text",
                                                           @"nickname":@"text primary key",
                                                           @"password":@"text",
                                                           @"website":@"text",
                                                           @"email":@"text",
                                                           @"category":@"text",
                                                           @"remark":@"text",
                                                           }];
    
    //创建表
    [[SSFMDBManager shareInstance] createTables];
}

- (id)init{
    if(self = [super init]){
        // 用queue的多线程操作效率要好于FMDataBase
        [self initialWithDBName:@"kkDateBase.db"];
    }
    return self;
}
//
+ (instancetype)shareInstance{
    static SSFMDBManager *dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[SSFMDBManager alloc]init];
    });
    return dbManager;
}

#pragma mark --创建数据库
-(void)initialWithDBName:(NSString *)dbName
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbPath = [doc stringByAppendingPathComponent:dbName];
    NSAssert([dbPath hasSuffix:@".db"], @"fmdb database should has .db suffix");
    
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    // 新建数据库
    void(^InitialDataBaseConfig)(FMDatabase *) = ^(FMDatabase *db){
        db.traceExecution = NO;
        db.checkedOut = NO;
#ifdef DEBUG
        db.crashOnErrors = YES;
#else
        db.crashOnErrors = NO;
#endif
        db.logsErrors = NO;
        self->_fmdb = db;
        NSLog(@"data base has created at: %@",dbPath);
    };
    [databaseQueue inDatabase:InitialDataBaseConfig];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-ddhh:mm:ssSSSS";
    [self->_fmdb setDateFormat:dateFormatter];
    self->_databaseQueue = databaseQueue;
}


#pragma mark --给指定数据库建表
-(void)prepareTableStatement:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes
{
    if (tableName.length > 0 && self->_fmdb && self->_databaseQueue && ![_fmdb tableExists:tableName]) {
        //创建自增主键
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        int count = 0;
        for (NSString *key in keyTypes) {
            count++;
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypes valueForKey:key]];
            if (count != [keyTypes count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@")"];
        [self.createTableStatements addObject:sql];
    }
}

- (void)createTables{
    [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [self.createTableStatements enumerateObjectsUsingBlock:^(NSString * _Nonnull statement, NSUInteger idx, BOOL * _Nonnull stop) {
            *rollback = ![db executeUpdate:statement];
        }];
    }];
}

-(BOOL)saveOrUpdateKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName{
    if (tableName.length > 0 && self->_databaseQueue) {
        //REPLACE INTO 删除旧值,插入新值
        //INSERT INTO DUPliCATE 插入新值或更新.
        NSArray *keys = [keyValues allKeys];
        NSArray *values = [keyValues allValues];
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"REPLACE INTO %@ (", tableName]];
        NSInteger count = 0;
        for (NSString *key in keys) {
            [sql appendString:key];
            count ++;
            if (count < [keys count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@") VALUES ("];
        for (int i = 0; i < [values count]; i++) {
            [sql appendString:@"?"];
            if (i < [values count] - 1) {
                [sql appendString:@","];
            }
        }
        [sql appendString:@")"];
        BOOL __block success = NO;
        [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            *rollback = ![db executeUpdate:sql withArgumentsInArray:values];
            success = !*rollback;
        }];
        return success;
    }else{
        return NO;
    }
}

- (void)updateTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues{
    if(keyValues.count == 0 || !tableName || keyValues.allKeys.count != keyValues.allValues.count){
        return;
    }
    NSArray *keys = [keyValues allKeys];
    NSArray *values = [keyValues allValues];
    NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"update %@ set ",tableName]];
    for (NSInteger i=0;i<keyValues.count;i++) {
        [sql appendFormat:@"%@=%@",keys[i],values[i]];
    }
    BOOL __block success = NO;
    [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        *rollback = ![db executeUpdate:sql withArgumentsInArray:values];
        success = !*rollback;
    }];
}

- (BOOL)update:(NSString *)updateSql{
    if(!updateSql){
        return NO;
    }
    BOOL __block updateSuccess = NO;
    NSString *us = [updateSql copy];
    [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        *rollback = ![db executeUpdate:us];
        updateSuccess = !*rollback;
    }];
    return updateSuccess;
}

- (BOOL)deleteFromTable:(NSString *)tableName whereCondition:(NSString *)whereCondition{
    if (tableName.length > 0 && self->_databaseQueue) {
        
        NSMutableString * __block sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"delete from %@ %@",tableName,whereCondition?:@""]];
        BOOL __block success = NO;
        [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            *rollback = ![db executeUpdate:sql];
            success = !*rollback;
        }];
        
        return success;
    }else{
        return NO;
    }
}

- (void)queryAllFromTable:(NSString *)tableName whereCondition:(NSString *)whereCondition sort:(NSString * )sort compeleteBlock:(void(^)(FMResultSet *resultSet))compeleteBlock{
    
    if (tableName.length > 0 && self->_databaseQueue) {
        
        NSMutableString *sql = nil;
        
        sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"select * from %@ %@ %@",tableName,whereCondition?:@"",sort?:@""]];
        
        if(!sql){
            return;
        }
        FMResultSet * __block result = nil;
        void(^resultBlock)(FMResultSet *resultSet) = [compeleteBlock copy];
        [self->_databaseQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            result = [db executeQuery:sql];
            if(resultBlock){
                resultBlock(result);
            }
        }];
    }else{
        if(compeleteBlock){
            compeleteBlock(nil);
        }
    }
}

- (void)query:(NSString *)sql compeleteBlock:(void(^)(FMResultSet *resultSet))compeleteBlock{
    if(!sql){
        if(compeleteBlock){
            compeleteBlock(nil);
        }
        return;
    }
    void(^resultBlock)(FMResultSet *resultSet) = [compeleteBlock copy];
    FMResultSet * __block result = nil;
    [self->_databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeQuery:sql];
        if(resultBlock){
            resultBlock(result);
        }
    }];
}
@end

