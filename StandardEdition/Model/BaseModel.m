//
//  BaseModel.m
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else if ([value isKindOfClass:[NSNull class]] || value==nil) {
        [self setValue:@"" forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (![key isEqualToString:@"id"] && ![key isEqualToString:@"description"])
        NSLog(@"UndefinedKey %@ - value %@ - class:%@",key,value,[self class]);    
}

@end
