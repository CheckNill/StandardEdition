//
//  CatagoryDetailController.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "BaseTableController.h"

@interface CatagoryDetailController : BaseTableController
//depend on category to select db
@property (strong, nonatomic) NSString *category;

@end
