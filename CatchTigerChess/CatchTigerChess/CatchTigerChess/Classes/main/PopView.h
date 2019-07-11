//
//  PopView.h
//  JuZhanGame
//
//  Created by zhizhuCon on 2019/3/22.
//  Copyright © 2019 ccc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^okButtonBlock)(void);
NS_ASSUME_NONNULL_BEGIN


@interface PopView : UIView

+(PopView *)sharedInstance;
-(void)showPopWithTitle:(NSString*)title supview:(UIView*)superView block:(okButtonBlock)block;

@end

NS_ASSUME_NONNULL_END
