//
//  HomeController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "HomeController.h"
#import "HomeCell.h"
#import "CategoryModel.h"
#import "CatagoryDetailController.h"
@interface HomeController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation HomeController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    [SSFMDBManager.shareInstance queryAllFromTable:@"tb_category" whereCondition:nil sort:@"order by category desc" compeleteBlock:^(FMResultSet *resultSet) {
        [self.dataArr removeAllObjects];
        while ([resultSet next]) {
            CategoryModel *modle = [CategoryModel HashModelWithResultSet:resultSet];
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

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"HomeCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self getData];
    if (!_manager) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"touchOnNumber"]) {//开始中
            vc.verifyType = VerifyTypeVerify;
            vc.first = YES;
            vc.block = ^(BOOL result) {
                if (result) {//开启成功
                    
                }
            };
            BaseNavController *nav = [[BaseNavController alloc]initWithRootViewController:vc];
            vc.navigationController.navigationBarHidden = YES;
            vc.HomeVerify = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
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
    HomeCell *cell = [HomeCell customCellWithtableView:tableView];
    CategoryModel *model = self.dataArr[indexPath.row];
    cell.titleLb.text = model.category;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count==0) {
        return;
    }
    CatagoryDetailController *vc = [[CatagoryDetailController alloc]init];
    vc.category = [self.dataArr[indexPath.row] category];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.manager;    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self DBdelete:[self.dataArr[indexPath.row] category]];
    }
}

-(void)DBdelete:(NSString *)category{
    BOOL reslut = [SSFMDBManager.shareInstance deleteFromTable:@"tb_category" whereCondition:[NSString stringWithFormat:@"where category='%@'",category]];
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
