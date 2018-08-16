//
//  CategoryModel.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel
+ (CategoryModel *)HashModelWithResultSet:(FMResultSet *)resultSet{
    if(!resultSet){
        return nil;
    }
    CategoryModel *hashModel = [[CategoryModel alloc] init];
    hashModel.category = [resultSet stringForColumn:@"category"];
    return hashModel;
}

@end
