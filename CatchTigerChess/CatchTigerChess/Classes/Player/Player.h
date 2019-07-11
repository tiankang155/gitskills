//
//  Player.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PlayerColor) {
    PlayerColorRed   = 1,
    PlayerColorBlack = 2,
};

@interface Player : NSObject

@property (nonatomic, assign) PlayerColor color;

// 默认是红色 hu  黑色 gou


@end
