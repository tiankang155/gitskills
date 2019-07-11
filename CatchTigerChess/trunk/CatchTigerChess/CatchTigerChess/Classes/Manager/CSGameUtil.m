//
//  CSGameUtil.m
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/31.
//  Copyright © 2018年 9377. All rights reserved.
//

#import "CSGameUtil.h"
#import "CSGameMgr.h"
//#import "CSGWKWebViewController.h"

@interface CSGameUtil(){
    BOOL isUseWKWebView;
}

@end

@implementation CSGameUtil

/*
 单例
 */
+(CSGameUtil *)sharedInstance{
    static CSGameUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSGameUtil alloc] init];
        [instance initUtil];
    });
    return instance;
}

-(void)initUtil{
    isUseWKWebView = YES;
}

/*
 请求游戏配制信息
 @block GameSwitchBlock 请求结果回调
 @param displayName 显示名
 */
-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block DisplayName:(NSString *)displayName{
    [[CSGameMgr sharedInstance] getGameSwitchWithBoolBlock:block DisplayName:displayName];
}

-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block  gameSwitchErrorBlock:(GameSwitchErrorBlock)errorBlock  DisplayName:(NSString *)displayName{
    [[CSGameMgr sharedInstance] getGameSwitchWithBoolBlock:block gameSwitchErrorBlock:errorBlock DisplayName:displayName];
}


/*
    获取游戏控制页面
    @gameUrl 游戏路径
    @return GameViewController
 */
-(UIViewController *)getGameViewControllerWithGameUrl:(NSString *)gameUrl{
    UIViewController *vc;
    if (isUseWKWebView) {

//        vc = [[CSGWKWebViewController alloc ] initWithGameUrl:gameUrl];
    }else{
        
        
     }
    
    return vc;
}

 


@end
