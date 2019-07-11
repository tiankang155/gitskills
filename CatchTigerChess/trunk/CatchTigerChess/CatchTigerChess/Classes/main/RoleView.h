//
//  RoleView.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^meCompletion)(NSInteger tag);//给block重命名,方便调用
@interface RoleView : UIView
@property (nonatomic,copy) meCompletion completion;
+(void)showRolViewWithCompletion:(void (^)(NSInteger tag))completion;
@end

NS_ASSUME_NONNULL_END
