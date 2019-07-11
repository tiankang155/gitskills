//
//  CSGSDKConfModel.h
//  CSGH5GameSDK
//
//  Created by 何浩 on 2019/2/19.
//  Copyright © 2019 9377. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSGSDKConfModel : NSObject

@property(nonatomic, strong) NSString *install_time;
@property(nonatomic, strong) NSString *display_name;
@property (nonatomic, assign) NSInteger install_time_int;
@end

NS_ASSUME_NONNULL_END
