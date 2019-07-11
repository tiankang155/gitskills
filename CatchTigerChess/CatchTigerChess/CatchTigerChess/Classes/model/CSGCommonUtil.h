//
//  CSGCommonUtil.h
//  CSGH5GameSDK
//
//  Created by 9377 on 2018/10/12.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGSDKConfModel.h"
#import <UIKit/UIKit.h>

@interface CSGCommonUtil : NSObject

+ (NSString *)timeIntervalString;

+ (NSString*)deviceImei;

+(NSString *)getReferer;

+ (NSString *)getIphoneTypeName;

+(NSString *)screenReslution;

+(NSString *)getSystemName;

+(NSString *)getCurrentOperators;

+(NSString *)ParameterSignWithTimestamp:(NSString *)timestamp gameID:(NSString *)gameID referer:(NSString *)referer;

+(NSString *)getDeviceLanguage;
    
+ (NSString *)getWifiName;

+(NSString *)getIMEI;

+ (NSString *)getUUID;

+(NSString *)getYYYmmddhhmmss;

+(CSGSDKConfModel *)getSDKConf;

+(NSString *)getLocalIP;

+(NSString *)getSystemVersion;

+(NSString *)getAppBuild;

+(NSString *)getAppVersion;

+(UIViewController *)getCurrentRootController;

@end
