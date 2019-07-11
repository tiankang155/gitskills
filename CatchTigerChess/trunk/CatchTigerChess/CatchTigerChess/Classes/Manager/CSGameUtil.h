//
//  CSGameUtil.h
//  CSGH5GameSDK
//
//  Created by on 2018/8/31.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSComm.h"
@interface CSGameUtil : NSObject
/*
 单例
 */
+(CSGameUtil *)sharedInstance;

/*
 请求游戏配制信息
 @block GameSwitchBlock 请求结果回调
 @param displayName 显示名
 */
-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block DisplayName:(NSString *)displayName;

-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block  gameSwitchErrorBlock:(GameSwitchErrorBlock)errorBlock  DisplayName:(NSString *)displayName;


/*
 获取游戏控制页面
 @gameUrl 游戏路径
 @return GameViewController
 */
-(UIViewController *)getGameViewControllerWithGameUrl:(NSString *)gameUrl;


@end
