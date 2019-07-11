//
//  CSHttpUtils.h
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/30.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSComm.h"

@interface CSHttpUtils : NSObject

// 单例
+(CSHttpUtils *)sharedInstance;

/*
    Post 请求
    @param  url http 全路径
    @param params 请求参数，如果直接带在url上，该值可为nil
    @param completeBlock 成功回调
    @param failedBlock 失败回调
 */
-(id)postUrl:(NSString *)url params:(NSMutableDictionary *)params completeBlock:(CompletionBlock)completeBlock failedBlock:(FailureBlock)failedBlock;


@end
