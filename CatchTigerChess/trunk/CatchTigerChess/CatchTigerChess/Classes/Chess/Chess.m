//
//  Chess.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "Chess.h"
#import "Chessboard.h"

#import "Chess+Move.h"

@implementation Chess

- (instancetype)initWithRowWidth:(CGFloat)rowWidth andRowLine:(NSIndexPath *)index{
    if (self = [super init]){
        _isInAir = NO;
        _index = index;
        _rowWidth = rowWidth;
        self.backgroundColor = [UIColor clearColor];
        //行
        NSInteger row = index.row;
        //列
        NSInteger line = index.section;
        if (row == 4 && line == 2) {
            _color = ChessTiger;
            [self addTarget:self action:@selector(tigerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self setImage:[UIImage imageNamed:@"hu"] forState:(UIControlStateNormal)];
            
        }else{
            _color = ChessDog;
            [self addTarget:self action:@selector(dogBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self setImage:[UIImage imageNamed:@"犬"] forState:(UIControlStateNormal)];
            
        }
        self.frame = CGRectMake(line * rowWidth - (btnWidth)/2.0, row * ((boardHeight)/6) - (btnWidth)/2.0, btnWidth, btnWidth);
 
//        self.categoryLabel = ({
//
//            UILabel * categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//
//            categoryLabel.textColor = _color == ChessTiger ? [UIColor redColor] : [UIColor blackColor];
//
//            categoryLabel.textAlignment = NSTextAlignmentCenter;
//
//            categoryLabel.adjustsFontSizeToFitWidth = YES;
//
//            categoryLabel.backgroundColor = [UIColor whiteColor];
//
//            categoryLabel.layer.cornerRadius = 50/2.0;
//
//            categoryLabel.clipsToBounds = YES;
//
//            categoryLabel.layer.borderColor = [UIColor grayColor].CGColor;
//            categoryLabel.layer.borderWidth = 2;
//
//            categoryLabel;
//        });
//        [self addSubview:_categoryLabel];
 
    }
    return self;
}

-(void)tigerBtnClick:(UIButton*)btn{
    Chessboard*board = [Chessboard sharedChessboard];
    if(board.whoFirstGo == NO) {
        NSLog(@"该狗走了!");
        return;
    }
    if(board.selectedChess) {
        if ([board.selectedChess isEqual:self]) {//点的是自己
            self.isInAir = !self.isInAir;
        }
    }else{
        self.isInAir = YES;
        board.selectedChess = self;
    }
}


-(void)dogBtnClick:(UIButton*)btn{
    Chessboard*board = [Chessboard sharedChessboard];
    if (board.whoFirstGo == YES) {
        NSLog(@"该老虎走了!");
        return;
    }
    if (board.selectedChess) {
        if ([board.selectedChess isEqual:self]) {//点的是自己
            self.isInAir = !self.isInAir;
        }else if(board.selectedChess.color == self.color){ //己方
            [board remCanMoveImageTips]; //删除提示坐标
            board.selectedChess.isInAir = NO;
            self.isInAir = YES;
            board.selectedChess = self;
//            NSLog(@"%@",board.canMoveList);
        }
    }else{
        self.isInAir = YES;
        board.selectedChess = self;
    }
}

- (void)setIsInAir:(BOOL)isInAir {
    _isInAir = isInAir;
    Chessboard*board = [Chessboard sharedChessboard];
    if (isInAir){
        if (self.color == ChessDog) {
            [self setImage:[UIImage imageNamed:@"犬选中_"] forState:(UIControlStateNormal)];
        }
        if (self.color == ChessTiger) {
            [self setImage:[UIImage imageNamed:@"老虎选中"] forState:(UIControlStateNormal)];
        }
        //查找能走位置
      board.canMoveList = [self selectCanMovePositionWithIndex:self.index];
    }else{
        //取消能走位置显示
        if (self.color == ChessDog) {
            [self setImage:[UIImage imageNamed:@"犬"] forState:(UIControlStateNormal)];
        }
        if (self.color == ChessTiger) {
            [self setImage:[UIImage imageNamed:@"hu"] forState:(UIControlStateNormal)];
        }
        [board remCanMoveImageTips]; //删除提示坐标
    }
}

-(void)setColor:(ChessColor)color{
    _color = color;
    if (color == ChessTiger) {
        _categoryLabel.textColor = [UIColor redColor];
    }else if (color == ChessDog) {
        _categoryLabel.textColor = [UIColor blackColor];
    }
}

// 由子类实现
-(BOOL)canMoveToIndex:(NSIndexPath *)index{
 
    return NO;
}

// 默认是能移动就能吃
- (BOOL)canEatIndex:(NSIndexPath *)index {
    if ([self canMoveToIndex:index]) {
        return YES;
    }
    return NO;
}


- (NSString *)description {

    return [NSString stringWithFormat:@"%@", self.categoryLabel.text];
}
@end
