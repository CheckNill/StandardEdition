//
//  SSFMDBManager.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface SSFMDBManager : NSObject
{
@public FMDatabase *_fmdb;
}

+ (instancetype)shareInstance;

/**
 初始化表结构
 */
- (void)setUpTables;
/**
 *  创建数据库
 *
 *  @param dbName 数据库名称(带后缀.db)
 */
-(void)initialWithDBName:(NSString *)dbName;

/**
 <#Description#>
 
 @param keyValues <#keyValues description#>
 @param tableName <#tableName description#>
 */
-(BOOL)saveOrUpdateKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName;

/**
 更新数据
 
 @param tableName <#tableName description#>
 @param keyValues <#keyValues description#>
 */
- (void)updateTable:(NSString *)tableName keyValues:(NSDictionary *)keyValues;
/**
 <#Description#>
 
 @param tableName <#tableName description#>
 @param whereCondition <#whereCondition description#>
 */
- (BOOL)deleteFromTable:(NSString *)tableName whereCondition:(NSString *)whereCondition;

/**
 是否更新成功
 
 @param updateSql <#updateSql description#>
 @return <#return value description#>
 */
- (BOOL)update:(NSString *)updateSql;

/**
 where查询语句,不自带where关键字
 
 @param tableName <#tableName description#>
 @param whereCondition <#whereCondition description#>
 @param sort <#sort description#>
 @param compeleteBlock <#compeleteBlock description#>
 */
- (void)queryAllFromTable:(NSString *)tableName whereCondition:(NSString *)whereCondition sort:(NSString * )sort compeleteBlock:(void(^)(FMResultSet *resultSet))compeleteBlock;


/**
 查询
 
 @param sql <#sql description#>
 @param compeleteBlock <#compeleteBlock description#>
 */
- (void)query:(NSString *)sql compeleteBlock:(void(^)(FMResultSet *resultSet))compeleteBlock;

@end
