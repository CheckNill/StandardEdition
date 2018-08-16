//
//  SearchDetailController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SearchDetailController.h"
#import "FavoriteModel.h"
#import "EditController.h"

@interface SearchDetailController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *cancel;
@property (nonatomic,strong) NSMutableArray *searchArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SSErrorView *errorView;
@end

@implementation SearchDetailController


-(SSErrorView *)errorView{
    if (_errorView==nil) {
        _errorView = [[SSErrorView alloc]initWithFrame:CGRectZero inView:self.tableView];
    }
    return _errorView;
}

-(UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)searchArr{
    if (_searchArr==nil) {
        _searchArr = [[NSMutableArray alloc]init];
    }
    return _searchArr;
}

-(UISearchBar *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, StatusBarHeight,ScreenWidth-75 , 34)];
        _searchBar.placeholder = SS_STR(@"Search With nickName");
        UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
        [_searchBar setBackgroundImage:searchBarBg];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    
    UIGraphicsBeginImageContext(r.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}

-(UIButton *)cancel{
    if (_cancel==nil) {
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame = CGRectMake(ScreenWidth-60, StatusBarHeight, 60, 34);
        _cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _cancel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        [_cancel setTitle:SS_STR(@"Cancel") forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancel addTarget:self action:@selector(btnCLick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

-(void)btnCLick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNav{
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TopHeight)];
    nav.backgroundColor = [UIColor colorWithHexString:@"#406ff4"];
    [self.view addSubview:nav];
    [nav addSubview:self.searchBar];
    [nav addSubview:self.cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initNav];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [UIView new];
    self.errorView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    return self.searchArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchArr.count<=indexPath.row) {
        return  nil;
    }
    FavoriteModel *model = self.searchArr[indexPath.row];
    cell.textLabel.text = model.nickname;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchArr removeAllObjects];
    NSString *text = searchBar.text;
    for (FavoriteModel *model in self.dataArr) {
        if ([model.nickname rangeOfString:text options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            [self.searchArr addObject:model];
        }
    }
    if (self.searchArr.count==0) {
        self.errorView.hidden=NO;
        [self.tableView reloadData];
    }else{
        self.errorView.hidden=YES;
       [self.tableView reloadData];
    }
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
