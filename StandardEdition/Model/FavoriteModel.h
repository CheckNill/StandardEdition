//
//  FavoriteModel.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "BaseModel.h"

@interface FavoriteModel : BaseModel
@property (strong, nonatomic) NSString *username;//@"text",
@property (strong, nonatomic) NSString *nickname;//@"text",
@property (strong, nonatomic) NSString *password;//@"text",
@property (strong, nonatomic) NSString *website;//@"text",
@property (strong, nonatomic) NSString *email;//@"text",
@property (strong, nonatomic) NSString *category;//@"text",
@property (strong, nonatomic) NSString *remark;//@"text",


+ (FavoriteModel *)HashModelWithResultSet:(FMResultSet *)resultSet;

@end
