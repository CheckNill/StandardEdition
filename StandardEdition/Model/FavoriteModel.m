//
//  FavoriteModel.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel
+ (FavoriteModel *)HashModelWithResultSet:(FMResultSet *)resultSet{
    if(!resultSet){
        return nil;
    }
    FavoriteModel *hashModel = [[FavoriteModel alloc] init];
    hashModel.category = [resultSet stringForColumn:@"category"];
    hashModel.username = [resultSet stringForColumn:@"username"];
    hashModel.nickname = [resultSet stringForColumn:@"nickname"];
    hashModel.password = [resultSet stringForColumn:@"password"];
    hashModel.website = [resultSet stringForColumn:@"website"];
    hashModel.email = [resultSet stringForColumn:@"email"];
    hashModel.remark = [resultSet stringForColumn:@"remark"];
    return hashModel;
}
@end
