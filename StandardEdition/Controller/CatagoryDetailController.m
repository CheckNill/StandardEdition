//
//  CatagoryDetailController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "CatagoryDetailController.h"
#import "FavoriteModel.h"
#import "HomeCell.h"
#import "EditController.h"
@interface CatagoryDetailController ()

@end

@implementation CatagoryDetailController

-(void)getData{
    [SSFMDBManager.shareInstance queryAllFromTable:@"tb_favorite" whereCondition:[NSString stringWithFormat:@"where category like '%%%@%%'",_category] sort:nil compeleteBlock:^(FMResultSet *resultSet) {
        [self.dataArr removeAllObjects];
        while ([resultSet next]) {
            FavoriteModel *modle = [FavoriteModel HashModelWithResultSet:resultSet];
            [self.dataArr addObject:modle];
        }
        if (self.dataArr.count==0) {
            self.errorView.hidden = NO;
            [self.tableView reloadData];
        }else{
            self.errorView.hidden = YES;
           [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnCLick)];
    self.navigationItem.rightBarButtonItem = item;    

}

-(void)btnCLick{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditController *vc = [story instantiateViewControllerWithIdentifier:@"EditController"];
    vc.category = self.category;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setCategory:(NSString *)category{
    _category = category;
    self.title = _category;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    FavoriteModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.nickname;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count==0) {
        return;
    }
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditController *vc = [story instantiateViewControllerWithIdentifier:@"EditController"];
    vc.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self DBdelete:[self.dataArr[indexPath.row] nickname]];
    }
}

-(void)DBdelete:(NSString *)nickName{
   BOOL reslut = [SSFMDBManager.shareInstance deleteFromTable:@"tb_favorite" whereCondition:[NSString stringWithFormat:@"where nickname='%@'",nickName]];
    [self.view displayError:SS_STR(@"Saving ...")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (reslut) {
            [self getData];
        }
    });
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
