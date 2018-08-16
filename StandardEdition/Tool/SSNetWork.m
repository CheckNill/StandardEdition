//
//  SSNetWork.m
//  StandardEdition
//
//  Created by Tony on 2018/8/16.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "SSNetWork.h"

@implementation SSNetWork
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static SSNetWork *network = nil;
    dispatch_once(&onceToken, ^{
        if (network==nil) {
           network = [[SSNetWork alloc]init];
            network.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://www.qslym.cn/"]];
            [network.manager.requestSerializer willChangeValueForKey:@"timeoutinterval"];
            [network.manager.requestSerializer didChangeValueForKey:@"timeoutinterval"];
            network.manager.responseSerializer = [AFJSONResponseSerializer serializer];
            network.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            network.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/plain", nil];
            [network.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        }
    });
    return network;
}

+(void)get:(NSString *)url param:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [SSNetWork.sharedInstance.manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            if (success) {
                success(responseObject);
            }
        }else{
            if (failure) {
                failure([NSError errorWithDomain:responseObject[@"message"] code:[responseObject[@"code"] integerValue] userInfo:nil]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)  failure(error);
    }];
}

@end
