//
//  AboutUsController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "AboutUsController.h"
#import <UIImageView+AFNetworking.h>
@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLb.text = [NSString stringWithFormat:@"%@:%@",SS_STR(@"Version"),app_Version];
}

-(void)getData{
    [SSNetWork get:@"aboutus" param:nil success:^(id respectObj) {
        NSString *url = respectObj[@"data"][0][@"img_url"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_img"]];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
