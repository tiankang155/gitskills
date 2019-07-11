//
//  CSComm.h
//  CSGH5GameSDK
//
//  Created by 9377 on 2018/8/31.
//  Copyright © 2018年 9377. All rights reserved.
//

#ifndef CSComm_h
#define CSComm_h


// 接口访问成功回调
typedef void (^CompletionBlock)(id result);

// 接口访问失败回调
typedef void (^FailureBlock)(id task, NSString *err);

// 游戏开关回调
typedef void (^GameSwitchBlock)(BOOL isSucc, NSString* gameUrl);
typedef void (^GameSwitchErrorBlock)( NSString* error);

// 无返回block
typedef void (^VoidBlock)(void);


#define kStringIsEmpty(str)     ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )


#ifdef DEBUG
#define NSLog(fmt,...)    NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NSLog(...)    (void)0
#endif



#endif /* CSComm_h */
