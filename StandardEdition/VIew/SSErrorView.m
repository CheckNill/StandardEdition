//
//  SSErrorView.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SSErrorView.h"

@implementation SSErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view{
    CGRect viewFrame = CGRectEqualToRect(frame, CGRectZero) ? CGRectMake(0, TopHeight, CGRectGetWidth([UIScreen mainScreen].bounds),300):CGRectMake(0, TopHeight, CGRectGetWidth(frame),300);
    self = [super initWithFrame:viewFrame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-105)*0.5, 100, 105, 93)];
        imgView.image = [UIImage imageNamed:@"illustration_emptystate"];
        [self addSubview:imgView];
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, self.frame.size.width, 100)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = SS_STR(@"no information!");
        [self addSubview:lb];
    }
    [view addSubview:self];
    return self;
}

@end
