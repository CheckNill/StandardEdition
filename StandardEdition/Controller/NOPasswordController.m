//
//  NOPasswordController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "NOPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface NOPasswordController ()
@property (nonatomic) BOOL touchOn;
@property (nonatomic,copy) NSString *password;
@property (strong, nonatomic) IBOutlet UILabel *titleOne;
@property (strong, nonatomic) IBOutlet UILabel *titleTwo;
@property (strong, nonatomic) IBOutlet UILabel *titleThree;
@property (strong, nonatomic) IBOutlet UILabel *attentionOne;
@property (strong, nonatomic) IBOutlet UILabel *attetntionTwo;
@property (strong, nonatomic) IBOutlet UIView *partOne;
@property (strong, nonatomic) IBOutlet UIView *partTwo;
@property (strong, nonatomic) IBOutlet UIView *partThree;

@end

@implementation NOPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.top.constant = iPhoneX?108:84;
    [self initUI];
}

-(void)initUI{
    if (self.touchID) {
        self.touchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"touchOn"];
        _partTwo.hidden = YES;
        _partThree.hidden = YES;
        _attentionOne.text = SS_STR(@"Tuoch ID can be used to retrieve and modified numeric passwords");
        _attetntionTwo.hidden = YES;
    }else{
        self.touchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"touchOnNumber"];
        if (self.touchOn) {
           _password = [[NSUserDefaults standardUserDefaults]valueForKey:@"passwordNumber"];
        }
    }
}

-(void)setTouchOn:(BOOL)touchOn{
    _touchOn = touchOn;
    self.switchBtn.on = _touchOn;
}


-(void)verifyTouchID:(void(^)(BOOL result))TouchBlock{
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"Forget passord";
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"Touch ID"
                      reply:^(BOOL success, NSError * _Nullable error) {
                          if (success) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (TouchBlock) {
                                      TouchBlock(YES);
                                  }
                                  self.touchOn = !self.touchOn;
                                    [[NSUserDefaults standardUserDefaults]setBool:self.touchOn forKey:@"touchOn"];
                              });
                          } else {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (TouchBlock) {
                                      TouchBlock(NO);
                                  }
                                  self.switchBtn.on = self.touchOn;
                              });
                          }
                      }];
    
}

- (IBAction)btnClick:(UISwitch *)sender {
    if (_touchID) {
        [self verifyTouchID:^(BOOL result) {
            
        }];
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
        if (self.touchOn) {//已开启
            
            vc.block = ^(BOOL result) {
                if (result) {//关闭成功
                    self.touchOn = NO;
                    [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                }
            };
            vc.verifyType = VerifyTypeVerify;
        }else{
            if (self.password!=nil && self.password.length !=0) {//曾经设置过
                vc.verifyType = VerifyTypeVerify;

                vc.block = ^(BOOL result) {
                    if (result) {//重新开启成功
                        self.touchOn = YES;
                        [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                    }
                };
            }else{
                vc.verifyType = VerifyTypeSetting;
                vc.first = YES;
                vc.block = ^(BOOL result) {
                    if (result) {//开启成功
                        self.touchOn = YES;
                        [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                    }
                };
            }
        }
        BaseNavController *nav = [[BaseNavController alloc]initWithRootViewController:vc];
        vc.navigationController.navigationBarHidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"touchOn"]) {//开始中
            [self verifyTouchID:^(BOOL result) {
                if (result) {
                    vc.verifyType = VerifyTypeSetting;
                    vc.first = YES;
                    vc.block = ^(BOOL result) {
                        if (result) {//开启成功
                            self.touchOn = YES;
                            [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                        }
                    };
                }else{
                    vc.verifyType = VerifyTypeSetting;
                    vc.first = YES;
                    vc.block = ^(BOOL result) {
                        if (result) {//
                            self.touchOn = YES;
                            [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                        }
                    };
                }
                BaseNavController *nav = [[BaseNavController alloc]initWithRootViewController:vc];
                vc.navigationController.navigationBarHidden = YES;
                [self presentViewController:nav animated:YES completion:nil];
            }];
    }else{
        if (tag == 20) {//验证+重置
            vc.verifyType = VerifyTypeResetting;
            vc.block = ^(BOOL result) {
                if (result) {//
                    self.touchOn = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                }
            };
        }else{//忘记就直接设置
            vc.verifyType = VerifyTypeSetting;
            vc.first = YES;
            vc.block = ^(BOOL result) {
                if (result) {//
                    self.touchOn = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:self.touchOn forKey:@"touchOnNumber"];
                }
            };
        }
        BaseNavController *nav = [[BaseNavController alloc]initWithRootViewController:vc];
        vc.navigationController.navigationBarHidden = YES;
        [self presentViewController:nav animated:YES completion:nil];

    }
    

}

- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error __attribute__((swift_error(none))){
    return YES;
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
