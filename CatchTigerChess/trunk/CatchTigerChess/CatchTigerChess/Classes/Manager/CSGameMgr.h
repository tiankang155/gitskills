//
//  CSGameMgr.h
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/30.
//  Copyright © 2018年 9377. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSBaseMgr.h"
#import "CSComm.h"

@interface CSGameMgr : CSBaseMgr

@property (nonatomic, strong) NSString *gameID;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *gameUrl;
@property (nonatomic, strong) NSString *tmpDisplayName;
@property (nonatomic, assign) BOOL  orientation;

// 单例
+(CSGameMgr *)sharedInstance;

/*
 请求游戏配制信息
 @block GameSwitchBlock 请求结果回调
 @param displayName 显示名
 */
-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block DisplayName:(NSString *)displayName;

-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block gameSwitchErrorBlock:(GameSwitchErrorBlock)errorBlock DisplayName:(NSString *)displayName;

@end
