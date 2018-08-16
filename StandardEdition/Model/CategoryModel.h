//
//  CategoryModel.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property (copy, nonatomic) NSString *category;

+ (CategoryModel *)HashModelWithResultSet:(FMResultSet *)resultSet;

@end
