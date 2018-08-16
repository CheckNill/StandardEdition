//
//  SettingController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SettingController.h"
#import "AboutUsController.h"
#import "HomeController.h"
#import "NOPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface SettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic) BOOL suportTouchID;
@end

@implementation SettingController

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    self.dataArr = @[@"Set Gusture password",@"Set Number password",@"Category Manager",@"About us"];
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        self.suportTouchID = YES;
        self.dataArr = @[SS_STR(@"Set TouchID"),SS_STR(@"Set Number password"),SS_STR(@"Category Manager"),SS_STR(@"About us")];
    }else{
        self.suportTouchID = NO;
        self.dataArr = @[SS_STR(@"Set Number password"),SS_STR(@"Category Manager"),SS_STR(@"About us")];

    }


    [self.tableView reloadData];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = COLOR_BACKGROUND;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, 20)];
    self.tableView.tableHeaderView = view;
    view.backgroundColor = COLOR_BACKGROUND;
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
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = self.suportTouchID? indexPath.row:indexPath.row+1;
    switch (row) {
        case 0:
            {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                NOPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"NOPasswordController"];
                vc.touchID = YES;
                vc.title = self.dataArr[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NOPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"NOPasswordController"];
            vc.title = self.dataArr[indexPath.row];            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeController *vc = [story instantiateViewControllerWithIdentifier:@"HomeController"];
            vc.title = self.dataArr[indexPath.row];
            vc.manager = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AboutUsController *vc = [story instantiateViewControllerWithIdentifier:@"AboutUsController"];
            vc.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
