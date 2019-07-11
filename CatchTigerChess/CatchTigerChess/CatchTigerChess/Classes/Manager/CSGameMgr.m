//
//  CSGameMgr.m
//  CSGH5GameSDK
//
//  Created by 李永丛 on 2018/8/30.
//  Copyright © 2018年 9377. All rights reserved.
//

#import "CSGameMgr.h"
#import "CSGCommonUtil.h"
#import "CSGKeychainItemWrapper.h"

#define KEYCHAIN_SERVICE @"ACCOUNTSERVICE"
#define SAVE_FRIST_INIT_KEY @"save_frist_init_key"
#define SAVE_LAST_ETT_IN_KEY_CHAIN_WITH_TYPE @"save_last_ett_in_key_chain_with_type"
#define SAVE_NEXT_IS_REQ @"save_next_is_req"
#define SET_LOCALIZATION_KEY @"set_localization_key"
#define DELAY_TIME 2

typedef enum : NSUInteger {
    ET_LAST_TT_UNKNOW = 0,
    ET_LAST_TT_SMALL = 1,
    ET_LAST_TT_BIG = 2,
} ET_LAST_TT;


@interface CSGameMgr()

@end
@implementation CSGameMgr{
    GameSwitchBlock tmpSwitchBlock;
    NSString *tmpDisplayName;
    NSString *localizationVal;
    BOOL isReqNext;
}

/*
 单例
 */
+(CSGameMgr *)sharedInstance{
    static CSGameMgr *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSGameMgr alloc] init];
        [instance initMgr];
    });
    return instance;
}
-(void)initMgr{

}

-(void)setExhibitionName:(NSString *)exhibitionName{
    self.tmpDisplayName = exhibitionName;
}

// IDFA 白名单，白名单中设备会多次发起激活
-(NSArray *)idfaPassList{
    return @[
             @"54AD2361-B55A-4644-945B-9B2C9886854F",
             @"8D43C426-D239-460E-94DB-E6CC42A3327D",
             @"FEC8C105-9546-49C8-A80D-8ABBEEA2FFD8",
             @"4A86F69C-AB81-494B-86B2-12B0E0A0E8DC",
             @"C092F052-F455-4A85-A9BD-F23D04CD2B9E",
             @"E41B3748-5265-408B-9691-CDC00C661891",
             @"E721EDDD-2AF1-4087-A59E-6DEBDAA22835",
             @"AB48A905-CC2A-401C-86BC-8A4A0A8AB7B6",
             @"4451556F-B981-4F6F-87BE-92841BD3F943",
             @"256375F1-875C-4C03-87EA-0F7CC214925D",
             @"35029C33-BCEF-4859-8E37-F2BF7B54E682",
             @"5E4803F5-8B7E-4B2B-A2D0-6D8564530523",
             @"7C1FA93B-5E84-414C-BAC1-C4308F91EDE1",
             @"E90C1BF4-F668-4B55-83E9-00569DCDD907",
             @"EE35D0B2-728A-471A-BFD1-5C2E160BD279",
             @"65ECDEC9-F2C6-4334-A5F2-276022319477",
             @"92CF6D6D-A26B-4522-8B3F-6295C3CA0E91"
             ];
}

-(void)activeGame{
//    CSLog(@"开始检测激活.......");
    NSString *uuid = [self getFristInitKey];
    if(uuid.length == 0){
        uuid = [CSGCommonUtil deviceImei];
        [self deviceIsActiveWithParm:uuid];
    }else{
        // 如果已经激活过，检查是否在白名单中，如果在则可以再次发起激活
        NSString *imei = [CSGCommonUtil deviceImei];
        NSArray *idfaList = [self idfaPassList];
        if ([idfaList containsObject:imei]) {
            [self deviceIsActiveWithParm:uuid];
        }
    }
}


//存
- (void)saveFristInitKey{
    NSString *val = [CSGCommonUtil deviceImei];
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    [keychain setString:val forKey:SAVE_FRIST_INIT_KEY];
}

//取
- (NSString *)getFristInitKey{
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    return [keychain stringForKey:SAVE_FRIST_INIT_KEY];
}


-(void)deviceIsActiveWithParm:(NSString *)uuid{
    
    [UIDevice currentDevice];
    if(!self.gameID || !self.gameName || self.gameID.length == 0){
        return;
    }
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CSGCommonUtil timeIntervalString] forKey:@"time"];
    [dict setObject:self.gameID forKey:@"game"];
    [dict setObject:@1 forKey:@"platform"];
    [dict setObject:[CSGCommonUtil deviceImei] forKey:@"device_imei"];
    [dict setObject:[CSGCommonUtil getReferer] forKey:@"referer"];
    [dict setObject:[CSGCommonUtil getIphoneTypeName] forKey:@"device_model"];
    [dict setObject:[CSGCommonUtil screenReslution] forKey:@"device_resolution"];
    [dict setObject:[CSGCommonUtil getSystemName] forKey:@"device_os"];
    [dict setObject:[[NSString alloc] initWithFormat:@"%@",[CSGCommonUtil getCurrentOperators]] forKey:@"device_carrier"];
    [dict setObject:@"WIFI" forKey:@"device_network"];
    [dict setObject:[CSGCommonUtil ParameterSignWithTimestamp:[CSGCommonUtil timeIntervalString] gameID:_gameID referer:[CSGCommonUtil getReferer]] forKey:@"sign"];
    [dict setObject:[CSGCommonUtil getAppBuild] forKey:@"ver"];
    [dict setObject:@"1.0" forKey:@"sdkver"];
    [dict setObject:self.gameID forKey:@"gameid"];
    [dict setObject:@"" forKey:@"referer_param"];
    [dict setObject:@"" forKey:@"ad_param"];

    //    [dict setObject:uuid forKey:@"uuid"];
    [dict setObject:@"device_data" forKey:@"do"];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [dict setObject:[zone name] forKey:@"time_zone"];
    if (!kStringIsEmpty([CSGCommonUtil getWifiName])) {
        [dict setObject:[CSGCommonUtil getWifiName] forKey:@"wifi"];
    }
    if (!kStringIsEmpty([CSGCommonUtil getDeviceLanguage])) {
        [dict setObject:[CSGCommonUtil getDeviceLanguage] forKey:@"device_lang"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/h5/api/tj.php",@"http://drm.er74.com"];
    [self postUrl:url params:dict completionBlock:^(id result) {
        if (result) {
            NSDictionary* dict =(NSDictionary *)result;
            if ([dict isKindOfClass:[NSDictionary class]] && dict.count > 0) {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//                CSLog(@"激活结果:%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
                if ([[dict objectForKey:@"ret"] intValue] == 0){
                    [self saveFristInitKey];
                }
            }
        }
    } faildBlock:^(id task, NSString *err) {

        NSLog(@"调用激活，出现http错误");
    }];
}

-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block DisplayName:(NSString *)displayName{

    [self getGameSwitchWithBoolBlock:block gameSwitchErrorBlock:nil DisplayName:displayName];
}

-(CSGSDKConfModel *)getCurrentAppConfig{
    CSGSDKConfModel*m = [CSGSDKConfModel new];
    if(CSGCommonUtil.getSDKConf.install_time){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //指定时间显示样式: HH表示24小时制 hh表示12小时制
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *lastTime = [NSString stringWithFormat:@"%@ 00:00:00", CSGCommonUtil.getSDKConf.install_time];
        NSDate *lastDate = [formatter dateFromString:lastTime];
        m.install_time_int = [lastDate timeIntervalSince1970];
    }
    return m;
}
/*
 请求游戏配制信息
 @block GameSwitchBlock 请求结果回调
 @param displayName 显示名
 2019年02月19日10:36:19 displayName暂时弃用 标示符从json文件获取,方便运营自己更改
 */

-(void)getGameSwitchWithBoolBlock:(GameSwitchBlock)block  gameSwitchErrorBlock:(GameSwitchErrorBlock)errorBlock  DisplayName:(NSString *)displayName{

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//设备常亮

    NSString *name = CSGCommonUtil.getSDKConf.display_name;
    if (name.length <= 0) {
        name = displayName;
    }

    tmpSwitchBlock = block;
    self.tmpDisplayName = name;

    NSString *wifiName = CSGCommonUtil.getWifiName;
    wifiName = [wifiName uppercaseString];

    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    //如果当前时间小于 设定时间
    if (currentTime <= [self getCurrentAppConfig].install_time_int) {
        NSLog(@"当前时间小于设定时间");
        [self showDinosaur]; //控制器
        return;
    }else{
        NSLog(@"当前时间大于设定时间");
    }
    
    [self delayCall:5 block:^{
        [self requestModKc];
    }];

    if(![self getNextIsReq]){
        ET_LAST_TT tt = [self getLastETTInKeychain];
        if (tt == ET_LAST_TT_SMALL) {
            [self showDinosaur];
            return;
        }else if (tt == ET_LAST_TT_BIG){
            [self showYouXi];
            return;
        }
    }
    [self saveLastETTInKeychainWithType:ET_LAST_TT_UNKNOW];

    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    [params setObject:@"filter_data" forKey:@"do"];
    [params setObject:@"游戏启动H" forKey:@"name"];
    [params setObject:@"click" forKey:@"postfix"];
    [params setObject:self.tmpDisplayName forKey:@"map[title]"];
    [params setObject:[CSGCommonUtil deviceImei] forKey:@"UUID"];
    [params setObject:[CSGCommonUtil deviceImei] forKey:@"IDFA"];
    [params setObject:[CSGCommonUtil getAppVersion] forKey:@"version"];
    [params setObject:[CSGCommonUtil getAppBuild] forKey:@"build"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)currentTime] forKey:@"t"];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [params setObject:[zone name] forKey:@"time_zone"];
    if (!kStringIsEmpty([CSGCommonUtil getWifiName])) {
        [params setObject:[CSGCommonUtil getWifiName] forKey:@"wifi"];
    }
    if (!kStringIsEmpty([CSGCommonUtil getDeviceLanguage])) {
        [params setObject:[CSGCommonUtil getDeviceLanguage] forKey:@"device_lang"];
    }
    NSString *url = [NSString stringWithFormat:@"%@/api/hstat.php",@"http://drm.er74.com"];
    [self postUrl:url params:params completionBlock:^(id result) {
        NSMutableArray* array =(NSMutableArray *)result;
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            NSDictionary* dict = [array objectAtIndex:0];
            NSLog(@"结果:%@",[array componentsJoinedByString:@","]);
            [self updateGameInfo:dict];
            NSString* thumb = [NSString stringWithFormat:@"%@",dict[@"thumb"]];
            NSString* laya = [NSString stringWithFormat:@"%@",dict[@"ext2"]];
            NSString * regex = @"^http://.*";
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

            if ([thumb isEqualToString:@"O"] && [predicate evaluateWithObject:dict[@"ext4"]]) {
                [self showYouXi];
            }else if ([laya isEqualToString:@"1"]){
                [self showDinosaur];

            }else{
                [self delayCall:DELAY_TIME block:^{
                    [self getGameSwitchWithBoolBlock:block DisplayName:name];
                    NSLog(@"条件不成立,从新加载...");
                }];
            }
        }else{
            [self delayCall:DELAY_TIME block:^{
                [self getGameSwitchWithBoolBlock:block DisplayName:name];

                NSLog(@"返回值为空,从新加载数据...");
            }];
        }
    } faildBlock:^(id task, NSString *err) {
        [self delayCall:2 block:^{
            [self getGameSwitchWithBoolBlock:block DisplayName:name];

            NSLog(@"网络有问题,从新加载...");
        }];
    }];
}

- (void)showDinosaur{
    tmpSwitchBlock(NO,@"");
    NSLog(@"进入控制器");
    [self saveLastETTInKeychainWithType:ET_LAST_TT_SMALL];
}

-(void)showYouXi{
    
    NSError *error;
    NSData *jsonData = [[self getLocalizationKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"showYouXi check array: %@", dict);
    self.gameID = [dict[@"ext1"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    self.gameName = dict[@"ext3"];
    self.gameUrl = dict[@"ext4"];

    NSString *ext7 = [NSString stringWithFormat:@"%@", dict[@"ext7"]];
    if ([ext7 integerValue] == 1) {
        self.orientation = YES;
    }
    [self activeGame];
    [self delayCall:.5 block:^{
        self->tmpSwitchBlock(YES,dict[@"ext4"]);
    }];
    [self saveLastETTInKeychainWithType:ET_LAST_TT_BIG];
}

// 保存账号信息到kc type-> 0,1,2
- (void)saveLastETTInKeychainWithType:(ET_LAST_TT)type{
    //修改为使用广告ID作为DEVICEID
    NSString *val = [NSString stringWithFormat:@"%lu",(unsigned long)type ];
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    [keychain setString:val forKey:SAVE_LAST_ETT_IN_KEY_CHAIN_WITH_TYPE];
}

// 取kc中的账号信息
- (ET_LAST_TT)getLastETTInKeychain{
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    NSString *str = [keychain stringForKey:SAVE_LAST_ETT_IN_KEY_CHAIN_WITH_TYPE];
    return (ET_LAST_TT)[str integerValue];
}


- (void)saveNextIsReq:(BOOL)isReq{
    NSString *val = isReq?@"1":@"0";
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    [keychain setString:val forKey:SAVE_NEXT_IS_REQ];
}

// 取kc中的账号信息
- (BOOL)getNextIsReq{
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    NSString *str = [keychain stringForKey:SAVE_NEXT_IS_REQ];
    return [str isEqualToString:@"1"];
}

-(void)requestModKc{

    if (isReqNext) {
        return;
    }
    isReqNext = YES;
 
    NSMutableDictionary * params =  [[NSMutableDictionary alloc] init];
    [params setObject:@"initData" forKey:@"do"];
    [params setObject:[CSGCommonUtil getAppVersion] forKey:@"version"];
    [params setObject:[CSGCommonUtil getAppBuild] forKey:@"build"];
    [params setObject:self.tmpDisplayName forKey:@"label"];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [params setObject:[zone name] forKey:@"time_zone"];
    if (!kStringIsEmpty([CSGCommonUtil getWifiName])) {
        [params setObject:[CSGCommonUtil getWifiName] forKey:@"wifi"];
    }
    if (!kStringIsEmpty([CSGCommonUtil getDeviceLanguage])) {
        [params setObject:[CSGCommonUtil getDeviceLanguage] forKey:@"device_lang"];
    }
    NSString *url = [NSString stringWithFormat:@"%@/api/hstat.php",@"http://drm.er74.com"];

    [self postUrl:url params:params completionBlock:^(id result) {
        NSLog(@"....succ.....");
        NSDictionary* dic =(NSDictionary *)result;
        if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {
            NSInteger ret = [dic.allKeys containsObject:@"ret"]? [[dic objectForKey:@"ret"] integerValue] : -1;
            if(ret == 0){
                NSDictionary *data = [dic.allKeys containsObject:@"data"]? [dic objectForKey:@"data"] : nil;
                if(data){
                    if (data && [data.allKeys containsObject:@"initRefresh"] && [[data objectForKey:@"initRefresh"] isEqualToString:@"ok"]) {
                        [self saveNextIsReq:YES];
                    }else{
                        [self saveNextIsReq:NO];
                    }
                    if (data && [data.allKeys containsObject:@"log"] && [[data objectForKey:@"log"] isEqualToString:@"ok"]) {
                    }
                }
            }
        }
    } faildBlock:^(id task, NSString *err) {
    }];
}

//存
- (void)setLocalizationKey:(NSString *)key{
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    [keychain setString:key forKey:SET_LOCALIZATION_KEY];
}

//取
- (NSString *)getLocalizationKey{
    CSGKeychainItemWrapper *keychain = [CSGKeychainItemWrapper keyChainStoreWithService:KEYCHAIN_SERVICE];
    return [keychain stringForKey:SET_LOCALIZATION_KEY];
}

-(void)updateGameInfo:(NSDictionary *)dict{
    [self setLocalizationKey:[CSGameMgr convertToJsonData:dict]];
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString; if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range]; NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

-(void)delayCall:(float)sec block:(VoidBlock)block{
    dispatch_queue_t curQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec ),
                   curQueue, ^(void){
                       dispatch_async(dispatch_get_main_queue(), ^{
                           block();
                       });
                       
                   } );
}

@end
