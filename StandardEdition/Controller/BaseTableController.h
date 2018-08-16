//
//  BaseTableController.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableController : UITableViewController
@property (strong, nonatomic) SSErrorView *errorView;
@property (nonatomic,strong) NSMutableArray *dataArr;


@end
