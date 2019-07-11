//
//  Map.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "Map.h"
#import "Chess.h"
#import "Chess+Move.h"
#import "Chessboard.h"
@implementation Map

- (instancetype)initWithStartPt:(CGPoint)pt andRowWidth:(CGFloat)rowWidth{
    if (self = [super init]){
        _rowWidth = rowWidth;
        self.frame = CGRectMake(pt.x, pt.y, rowWidth*4, boardHeight);
        self.backgroundColor = [UIColor clearColor];
        for (int i = 0; i<5; i++) {
            UIView * line = [[UIView alloc]init];
            line.backgroundColor = [UIColor clearColor];
            line.frame =CGRectMake(i * rowWidth - 1 , 0, 2 ,  self.frame.size.height);
            [self addSubview:line];
        }
        //画行线
        for (int i = 0; i < 7; i++){
            UIView * line = [[UIView alloc]init];
            line.frame = CGRectMake(0, i * (boardHeight)/6 - 1 , self.frame.size.width , 2);
            line.backgroundColor = [UIColor clearColor];
            [self addSubview:line];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint  pt = [touch locationInView:self];
    NSInteger row = floor((pt.y - ((boardHeight)/6)/2.0)  / ((boardHeight)/6)) + 1;
    NSInteger line = floor((pt.x - _rowWidth/2.0)  / _rowWidth) + 1;
    NSIndexPath*index = [NSIndexPath indexPathForRow:row inSection:line]; 
    //排除不能点击的位置
    if ((row == 0 && line == 0) ||
        (row == 0 && line == 1) ||
        (row == 0 && line == 3) ||
        (row == 0 && line == 4) ||
        (row == 1 && line == 0) ||
        (row == 1 && line == 4)) {
        return;
    }
    for (UIView*view in self.subviews) {
        if ([view isKindOfClass:[Chess class]]) {
            Chess*chess = (Chess*)view;
            if(chess.isInAir){
                if([chess canMoveToIndex:index]){
                    self.superview.userInteractionEnabled = NO; //解决连续多次点击能走的点 移动多次的BUG
                    [chess moveToIndex:index completion:^{
                        [self remCanMoveImageTips];
                        self.superview.userInteractionEnabled = YES;
                    }];
                }
            }
        }
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

-(void)remCanMoveImageTips{
    for (UIView*view1 in self.subviews) {
        if ([view1 isKindOfClass:[UIImageView class]]) {
            UIImageView*image= (UIImageView*)view1;
            [image removeFromSuperview];
        }
    }
}

@end
