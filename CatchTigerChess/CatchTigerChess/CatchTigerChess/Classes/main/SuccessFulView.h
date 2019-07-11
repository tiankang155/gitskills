//
//  SuccessFulView.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^myCompletion)();//给block重命名,方便调用

@interface SuccessFulView : UIView
@property (nonatomic,copy) myCompletion completion;
 
+(void)showSuccessFulViewWithImageName:(NSString*)name completion:(void (^)())completion;

@end

NS_ASSUME_NONNULL_END
