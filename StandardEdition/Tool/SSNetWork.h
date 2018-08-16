//
//  SSNetWork.h
//  StandardEdition
//
//  Created by Tony on 2018/8/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface SSNetWork : NSObject
+(instancetype)sharedInstance;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
+ (void)get:(NSString *)url param:(NSDictionary *)param success:(void(^)(id respectObj))success failure:(void(^)(NSError *error))failure;


@end
