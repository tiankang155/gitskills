//
//  Map.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Map : UIView

/**
 *  每格的宽度
 */
@property (nonatomic,assign)CGFloat rowWidth;

-(void)remCanMoveImageTips;

- (instancetype)initWithStartPt:(CGPoint)pt andRowWidth:(CGFloat)rowWidth;
@end
