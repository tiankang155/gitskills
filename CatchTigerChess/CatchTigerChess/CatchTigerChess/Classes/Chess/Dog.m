//
//  Dog.m
//  CatchTigerChess
//
//  Created by 田亢 on 2019/6/25.
//  Copyright © 2019 ccc. All rights reserved.
//

#import "Dog.h"
#import "Chessboard.h"
@implementation Dog

- (instancetype)initWithRowWidth:(CGFloat)rowWidth andRowLine:(NSIndexPath *)index{
    if (self = [super initWithRowWidth:rowWidth andRowLine:index]){
        self.categoryLabel.text = @"犬";
    }
    return self;
}
-(BOOL)canMoveToIndex:(NSIndexPath *)index{
    
    NSInteger  toRow = index.row;
    NSInteger  toLine = index.section;
    NSInteger  fromRow = self.index.row;
    NSInteger  fromLine = self.index.section;
    Chessboard *board = [Chessboard sharedChessboard];

    if ((fromRow ==2 && fromLine ==0) && (toLine == 1 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==2 && fromLine ==1) && (toLine == 2 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==2 && fromLine ==1) && (toLine == 1 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==2 && fromLine ==3) && (toLine == 2 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==2 && fromLine ==3) && (toLine == 3 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==2 && fromLine ==4) && (toLine == 3 && toRow == 1)) {
        return NO;
    }
    if ((fromRow ==1 && fromLine ==1) && (toLine == 1 && toRow == 2)) {
        return NO;
    }
    if ((fromRow ==1 && fromLine ==3) && (toLine == 3 && toRow == 2)) {
        return NO;
    }
    if ((fromRow ==1 && fromLine ==2) && (toLine == 1 && toRow == 2)) {
        return NO;
    }
    if ((fromRow ==1 && fromLine ==2) && (toLine == 3 && toRow == 2)) {
        return NO;
    }
    
    if ([board chessOnRow:toRow section:toLine]) {
        return NO;
    }
    if (ABS(toRow - fromRow) == 1 && ABS(toLine - fromLine) == 1) { // 上下
       return YES;
    }
    if (toLine == fromLine && toRow - fromRow == 1) { // 上
        return YES;
    }else if (toRow == fromRow && toLine - fromLine == -1) {  // 左
        return YES;
    }else if (toRow == fromRow && toLine - fromLine == 1) {  // 右
        return YES;
    }else if (toLine == fromLine && toRow-fromRow == -1){ //下
        return YES;
    }
    
    
    return NO;
}
@end
