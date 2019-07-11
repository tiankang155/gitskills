//
//  RoleView.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "RoleView.h"

@implementation RoleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews{
    UIImageView*bgImaeView = [self creatImageViewWithName:@"选择身份框" superView:self];
    bgImaeView.center = self.center;
    bgImaeView.bounds = CGRectMake(0, 0, 310, 270);
    
    UIImageView*titleImage = [self creatImageViewWithName:@"游戏开始请选择身份" superView:bgImaeView];
    titleImage.frame = CGRectMake(30, 40, 250, 60);
    
    UIButton*tigerBtn = [self creatBtnWithImage:@"选择老虎" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:1 superView:bgImaeView];
    tigerBtn.frame = CGRectMake((bgImaeView.width-150)/2, titleImage.y+80, 150, 40);
    tigerBtn.tag = 100;
    [tigerBtn addTarget:self action:@selector(tigerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton*dogBtn = [self creatBtnWithImage:@"选择猎人" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:1 superView:bgImaeView];
    dogBtn.frame = CGRectMake(tigerBtn.x, tigerBtn.y+55, tigerBtn.width, tigerBtn.height);
    dogBtn.tag = 110;
    [dogBtn addTarget:self action:@selector(tigerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

+(void)showRolViewWithCompletion:(void (^)(NSInteger tag))completion;{
    
    RoleView*view = [[RoleView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
 
    view.completion = completion;
}

-(void)tigerBtnAction:(UIButton*)btn{
    if (self.completion) {
        self.completion(btn.tag);
    }
    [self removeFromSuperview];
}

@end
