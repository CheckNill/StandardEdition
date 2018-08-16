//
//  VerifyPasswordController.h
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VerifyType) {
    VerifyTypeSetting,//设置
    VerifyTypeVerify,//关闭，打开校验
    VerifyTypeResetting,//根据密码重置
};
@interface VerifyPasswordController : UIViewController

@property (nonatomic,strong) void(^block)(BOOL result);
@property (nonatomic) BOOL first;
@property (nonatomic,copy) NSString *password;
@property (nonatomic) VerifyType verifyType;

@property (nonatomic) BOOL HomeVerify;
@property (nonatomic) BOOL popType;
@end
