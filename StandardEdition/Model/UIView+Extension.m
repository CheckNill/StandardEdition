//
//  UIView+Extension.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
- (void)displayError:(NSString *)error {
    if(error.length > 0){
        [SVProgressHUD setContainerView:self];
        [SVProgressHUD showInfoWithStatus:error];
        [SVProgressHUD dismissWithDelay:1.0];
        [SVProgressHUD setContainerView:nil];
    }
}
@end
