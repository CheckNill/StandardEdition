//
//  VerifyPasswordController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "VerifyPasswordController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface VerifyPasswordController ()
@property (nonatomic,strong) NSDictionary *dictPw;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *attentionLb;

@property (strong, nonatomic) IBOutlet UITextField *tf1;
@property (strong, nonatomic) IBOutlet UITextField *tf2;
@property (strong, nonatomic) IBOutlet UITextField *tf3;
@property (strong, nonatomic) IBOutlet UITextField *tf4;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@property (strong, nonatomic) IBOutlet UIButton *forgetBtn;


@end

@implementation VerifyPasswordController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTextFieldDidEndEditing:) name:UITextFieldTextDidChangeNotification object:nil];
    [_tf1 becomeFirstResponder];
    _closeBtn.userInteractionEnabled = !self.HomeVerify;
    _forgetBtn.hidden = ![[NSUserDefaults standardUserDefaults]boolForKey:@"touchOn"];
    
    if (_verifyType == VerifyTypeVerify) {
        _titleLb.text = SS_STR(@"Verify Password");
    }else if (_verifyType == VerifyTypeSetting){
        
        _titleLb.text = _first?SS_STR(@"Setting Password"):SS_STR(@"Confirm Password");
    }else{
        _titleLb.text = SS_STR(@"Verify Password");
    }
}


- (void)contentTextFieldDidEndEditing:(NSNotification *)noti {
    
    UITextField *textField = noti.object;
    
    NSString *text = textField.text;
    UITextField *next = (UITextField *)[self.view viewWithTag:textField.tag+1];
    switch (textField.tag) {
        case 30:
        case 31:
        case 32:
        {
            if (text.length!=0) {
                [next becomeFirstResponder];
            }
        }
            break;
        default:{
            if (_verifyType == VerifyTypeVerify) {
                [self VerifyPW:YES];
            }else if(_verifyType == VerifyTypeSetting){
                if (_first) {
                    [self settingFirst];
                }else{
                    [self settingSecond];
                }
            }else{//VerifyTypeResetting
                [self VerifyPW:NO];
            }
            
        }
            break;
    }
}

-(void)settingFirst{
    if (_tf1.text.length!=0 && _tf2.text.length!=0 && _tf3.text.length!=0 && _tf4.text.length!=0) {
        self.password = [NSString stringWithFormat:@"%@%@%@%@",_tf1.text,_tf2.text,_tf3.text,_tf4.text];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
        vc.block = self.block;
        vc.first = NO;
        vc.password = self.password;
        vc.verifyType = self.verifyType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//use touchID
- (void)forgetPw:(id)sender {
    [self verifyTouchID:^(BOOL result) {
        if (result) {//成功
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
            vc.verifyType = VerifyTypeSetting;
            vc.first = YES;
            vc.block = ^(BOOL result) {
                
            };
            vc.navigationController.navigationBarHidden = YES;
            vc.popType = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
        }
    }];
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
                              });
                          } else {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (TouchBlock) {
                                      TouchBlock(NO);
                                  }
                              });
                          }
                      }];
    
}

-(void)settingSecond{
    if (_tf1.text.length!=0 && _tf2.text.length!=0 && _tf3.text.length!=0 && _tf4.text.length!=0) {
        NSString *passwordN = [NSString stringWithFormat:@"%@%@%@%@",_tf1.text,_tf2.text,_tf3.text,_tf4.text];
        if ([passwordN isEqualToString:self.password]) {
            [[NSUserDefaults standardUserDefaults]setValue:self.password forKey:@"passwordNumber"];
            [self.view displayError:@"设置密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.block(YES);
                [self dismissViewControllerAnimated:YES completion:nil];
                
            });
        }else{
            
        }
    }
}

-(void)VerifyPW:(BOOL)status{
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:@"passwordNumber"];
    if (_tf1.text.length!=0 && _tf2.text.length!=0 && _tf3.text.length!=0 && _tf4.text.length!=0) {
        
        NSString *passwordN = [NSString stringWithFormat:@"%@%@%@%@",_tf1.text,_tf2.text,_tf3.text,_tf4.text];
        if (status) {
            if ([passwordN isEqualToString:self.password]) {
                [self.view displayError:SS_STR(@"Dense successor success")];
                self.block(YES);
            }else{
                [self.view displayError:SS_STR(@"Dense school losing loss")];
                self.block(NO);
                if (self.HomeVerify) return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            if ([passwordN isEqualToString:self.password]) {
                [self.view displayError:SS_STR(@"Dense successor success")];
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                VerifyPasswordController *vc = [story instantiateViewControllerWithIdentifier:@"VerifyPasswordController"];
                vc.verifyType = VerifyTypeSetting;
                vc.block = self.block;
                vc.first = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self.view displayError:SS_STR(@"Dense school losing loss")];
                self.block(NO);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag==20) {
        if (_block)    _block(NO);
        if (_popType) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self forgetPw:sender];
    }
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
