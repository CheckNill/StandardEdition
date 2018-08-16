//
//  EditController.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "EditController.h"
#import "CatagoryGorupController.h"

@interface EditController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIButton *eyeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHight;

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    if (_category!=nil) {
        _categoryT.text = _category;
    }
    if (_model!=nil) {
        _userNameT.text = _model.username;
        _nickNameT.text = _model.nickname;
        _passwordT.text = _model.password;
        _webSiteT.text = _model.website;
        _emailT.text = _model.email;
        _categoryT.text = _model.category;
        _remarkT.text = _model.remark;
    }
    _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _eyeButton.frame = CGRectMake(0, 0, 22, 22);
    [_eyeButton setImage:[UIImage imageNamed:@"icon_eye_on"] forState:UIControlStateSelected];
    [_eyeButton setImage:[UIImage imageNamed:@"icon_eye_off"] forState:UIControlStateNormal];
    [_eyeButton addTarget:self action:@selector(securite:) forControlEvents:UIControlEventTouchUpInside];
    _passwordT.rightViewMode = UITextFieldViewModeAlways;
    _passwordT.rightView = _eyeButton;
    _passwordT.secureTextEntry = YES;
    _topHight.constant = iPhoneX?88.0:64.0;    

}

-(void)securite:(UIButton *)btn{
    btn.selected = !btn.selected;
    _passwordT.secureTextEntry = !btn.selected;
}

-(void)insertTb_favorite{
    BOOL result = [SSFMDBManager.shareInstance saveOrUpdateKeyValues:@{
                                                                       @"username":_userNameT.text,
                                                                       @"nickname":_nickNameT.text,
                                                                       @"password":_passwordT.text,
                                                                       @"website":_webSiteT.text,
                                                                       @"email":_emailT.text,
                                                                       @"category":_categoryT.text,
                                                                       @"remark":_remarkT.text,
                                                                       } intoTable:@"tb_favorite"];
    [self.view displayError:SS_STR(@"Saving ...")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (result) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}



- (IBAction)btnClick:(UIBarButtonItem *)sender {
    if (_categoryT.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SS_STR(@"please select catagory") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:SS_STR(@"OK") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }else if (_nickNameT.text.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SS_STR(@"nickName can't be nil") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:SS_STR(@"OK") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:SS_STR(@"Cancel") style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:SS_STR(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertTb_favorite];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 20) {
        [self selectCatagory];
        return NO;
    }else{
        return YES;
    }
}

-(void)selectCatagory{
    CatagoryGorupController *vc = [[CatagoryGorupController alloc]init];
    vc.block = ^(NSString *category) {
        self.categoryT.text = category;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
