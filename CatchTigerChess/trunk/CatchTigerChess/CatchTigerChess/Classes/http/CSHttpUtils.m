//
//  CSHttpUtils.m
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/30.
//  Copyright © 2018年 9377. All rights reserved.
//

#import "CSHttpUtils.h"
#import "CSAFNetworking.h"


@implementation CSHttpUtils


/*
    单例
 */
+(CSHttpUtils *)sharedInstance{
    static CSHttpUtils *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSHttpUtils alloc] init];
    });
    return instance;
}


// 安全协议
-(CSAFSecurityPolicy *)currentSecPolicy{
    CSAFSecurityPolicy *securityPolicy = [CSAFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

// 获取 AFHTTPSessionManager 设置一些常用属性
-(CSAFHTTPSessionManager *)getAFNManager{
    CSAFHTTPSessionManager *manager = [CSAFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 60.0f;
    manager.responseSerializer = [CSAFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"en" forHTTPHeaderField:@"Accept-Language"];
    // 为了防止dns劫持，可以使用host反查到ip，更新请求地址，但这里需要设定host
    //[manager.requestSerializer setValue:[[AppServerMgr sharedInstance] getApiHost] forHTTPHeaderField:@"HOST"];
    manager.securityPolicy = [self currentSecPolicy];
    return manager;
}

/*
 Post 请求
 @param  url http 全路径
 @param params 请求参数，如果直接带在url上，该值可为nil
 @param completeBlock 成功回调
 @param failedBlock 失败回调
 */
-(id)postUrl:(NSString *)url params:(NSMutableDictionary *)params completeBlock:(CompletionBlock)completeBlock failedBlock:(FailureBlock)failedBlock{

//    CSLog(@"post : Url ->%@, 参数： %@", url, params);
    NSMutableString *bodyStr = [[NSMutableString alloc] init];
    for (NSString *key in params.allKeys) {
        NSString *val = [params objectForKey:key];
        val = [[NSString stringWithFormat:@"%@", val] stringByRemovingPercentEncoding];
        if(bodyStr.length == 0){
            [bodyStr appendString:[NSString stringWithFormat:@"%@=%@", key, val]];
        }else{
            [bodyStr appendString:[NSString stringWithFormat:@"&%@=%@", key, val]];
        }
    }
//    CSLog(@"---------------------------------API--------------------------------------------- REQUEST------------------------------------");
//    CSLog(@"Request Api:%@?%@", url, bodyStr);
    
    CSAFHTTPSessionManager *manager = [self getAFNManager];
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id _Nullable responseObject){
        completeBlock(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError *error){
        failedBlock(task, @"");
    }];
    return nil;
}

@end
