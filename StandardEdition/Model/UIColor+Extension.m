//
//  UIColor+Extension.m
//  StandardEdition
//
//  Created by Tony on 2018/8/15.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
+ (UIColor *)colorWithHexString:(NSString*) hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    NSString *_hexColor = hexColor;
    if(![_hexColor hasPrefix:@"#"]){
        _hexColor = [NSString stringWithFormat:@"#%@",_hexColor];
    }
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[_hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 3;
    [[NSScanner scannerWithString:[_hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 5;
    [[NSScanner scannerWithString:[_hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor* retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    return retColor;
}
@end
