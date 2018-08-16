//
//  HomeCell.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLb;

+(HomeCell *)customCellWithtableView:(UITableView *)tableView;
@end
