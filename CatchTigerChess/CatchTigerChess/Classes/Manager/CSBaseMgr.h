//
//  CSBaseMgr.h
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/31.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CSHttpUtils.h"
#import "CSComm.h"
@interface CSBaseMgr : NSObject


/*
 @params url 不带参数;
 @params params; 参数值 KEY VALUE
 @params completionBlock; HTTP成功回调
 @params faildBlock；HTTP失败回调
 @return NSURLSessionDataTask
 */
-(id)postUrl:(NSString *)url params:(NSMutableDictionary *)params completionBlock:(CompletionBlock) completionBlock faildBlock:(FailureBlock) faildBlock;

/*
 @params url 不要带参数;
 @params params; 参数值 KEY VALUE
 @params datas; 文件对应KEV VALUE
 @params updateError 是否上载错误信息
 @params completionBlock; HTTP成功回调
 @params faildBlock；HTTP失败回调
 */
- (id) postUrl:(NSString*)url params:(NSMutableDictionary *)params datas:(NSMutableDictionary *)datas wait:(BOOL)wait uploadError:(BOOL)updateError completionBlock:(CompletionBlock) completionBlock faildBlock:(FailureBlock) faildBlock;

@end
