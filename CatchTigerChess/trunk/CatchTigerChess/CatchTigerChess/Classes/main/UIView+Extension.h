//
//  UIView+Extension.h

//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end


@interface UIView (CreatUI)

-(UIButton*)creatBtnWithImage:(NSString*)image seletImage:(NSString*)sName  title:(NSString*)title titleColor:(UIColor*)tColor bgColor:(UIColor*)color  isClip:(BOOL)isClip size:(CGFloat)size superView:(UIView*)view;

-(UIImageView*)creatImageViewWithName:(NSString*)name superView:(UIView*)view;

-(UILabel*)creatLabelWithTitle:(NSString*)title alignment:(NSTextAlignment)alignment textColor:(UIColor*)textColor size:(CGFloat)size superView:(UIView*)view;

-(UITextField*)creatTextFieldWithPlaceholder:(NSString*)placeholder textEntry:(BOOL)textEntry iconViewName:(NSString*)name superView:(UIView*)view;

@end
