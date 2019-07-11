//
//  SuccessFulView.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "SuccessFulView.h"

@implementation SuccessFulView{
    
}

+(void)showSuccessFulViewWithImageName:(NSString*)name completion:(void (^)())completion{
  
    SuccessFulView*view = [[SuccessFulView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    UIImageView*imageView = [view creatImageViewWithName:name superView:view];
    imageView.center = view.center;
    imageView.bounds = CGRectMake(0, 0, 270, 110);
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.completion = completion;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
//    if (self.completion) {
         self.completion();
//    }
   
    
}

@end
