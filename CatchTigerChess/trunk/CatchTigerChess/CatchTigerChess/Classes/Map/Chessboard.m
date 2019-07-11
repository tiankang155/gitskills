//
//  Chessboard.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "Chessboard.h"
#import "Chess+Move.h"
#import "Dog.h"
#import "Tiger.h"
@implementation Chessboard
singleton_implementation(Chessboard)

- (instancetype)initWithStartPt:(CGPoint)pt andRowWidth:(CGFloat)rowWidth{
    if (self = [super initWithStartPt:pt andRowWidth:rowWidth]){
       _chessArr = [NSMutableArray array];
    }
 
    return self;
}


-(Chess *)chessOnRow:(NSInteger)row section:(NSInteger)section {
    for (Chess *chess in self.chessArr) {
        if (chess.index.row == row && chess.index.section == section) {
            return chess;
            break;
        }
    }
    return nil;
}

-(Chess *)chessIsExist:(NSIndexPath*)index{
    for (Chess *chess in self.chessArr) {
        if (chess.index.row == index.row && chess.index.section == index.section) {
            return chess;
            break;
        }
    }
    return nil;
}


-(void)initChessboard {
    [self initRed];
    [self initBlack];
}

-(void)initRed {
    Tiger*tiger = [[Tiger alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:4 inSection:2]];
    [self addSubview:tiger];
    self.tigerChess = tiger;
    self.tigerChess.index = [NSIndexPath indexPathForRow:4 inSection:2];
    [self.chessArr addObject:tiger];
}

-(void)initBlack {
    Dog*dog = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self addSubview:dog];
    [self.chessArr addObject:dog];
    
    Dog*dog1 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:2 inSection:1]];
    [self addSubview:dog1];
    [self.chessArr addObject:dog1];
    
    Dog*dog2 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:2 inSection:2]];
    [self addSubview:dog2];
    [self.chessArr addObject:dog2];
    
    Dog*dog3 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:2 inSection:3]];
    [self addSubview:dog3];
    [self.chessArr addObject:dog3];
    
    Dog*dog4 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:2 inSection:4]];
    [self addSubview:dog4];
    [self.chessArr addObject:dog4];
    
    Dog*dog5 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:3 inSection:0]];
    [self addSubview:dog5];
    [self.chessArr addObject:dog5];
    
    Dog*dog6 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:3 inSection:4]];
    [self addSubview:dog6];
    [self.chessArr addObject:dog6];
    
    Dog*dog7 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:4 inSection:0]];
    [self addSubview:dog7];
    [self.chessArr addObject:dog7];
    
    Dog*dog8 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:4 inSection:4]];
    [self addSubview:dog8];
    [self.chessArr addObject:dog8];
    
    Dog*dog9 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:5 inSection:0]];
    [self addSubview:dog9];
    [self.chessArr addObject:dog9];
    
    Dog*dog10 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:5 inSection:4]];
    [self addSubview:dog10];
    [self.chessArr addObject:dog10];
    
    Dog*dog11 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:6 inSection:0]];
    [self addSubview:dog11];
    [self.chessArr addObject:dog11];
    
    Dog*dog12 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:6 inSection:1]];
    [self addSubview:dog12];
    [self.chessArr addObject:dog12];
    
    Dog*dog13 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:6 inSection:2]];
    [self addSubview:dog13];
    [self.chessArr addObject:dog13];
    
    Dog*dog14 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:6 inSection:3]];
    [self addSubview:dog14];
    [self.chessArr addObject:dog14];
    
    Dog*dog15 = [[Dog alloc]initWithRowWidth:self.rowWidth andRowLine:[NSIndexPath indexPathForRow:6 inSection:4]];
    [self addSubview:dog15];
    [self.chessArr addObject:dog15];
}

-(void)setWhoFirstGo:(BOOL)whoFirstGo{
    _whoFirstGo = whoFirstGo;
    if ([self.delegate respondsToSelector:@selector(chessBoardWhoGo:)]) {
        [self.delegate chessBoardWhoGo:whoFirstGo];
    }
}
- (void)moveIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex {

    Chess *chess = [self chessOnRow:fromIndex.row section:fromIndex.section];
    if (chess) {
        [chess moveToIndex:toIndex completion:nil];
    }
}

- (void)setCanMoveList:(NSMutableArray<NSIndexPath *> *)canMoveList{
    _canMoveList = canMoveList;
 
    [self initCanMovePositionChessWithList:canMoveList];
  
}
//重置
-(void)resetBoardChessPosition{
   
    for (UIView*view in self.subviews) {
        if ([view isKindOfClass:[Chess class]]) {
            Chess*chess = (Chess*)view;
            [chess removeFromSuperview];
        }
    }
    [self remCanMoveImageTips];
    [self.chessArr removeAllObjects];
    [self initChessboard];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetBoard" object:nil];
}

-(void)initCanMovePositionChessWithList:(NSMutableArray*)list{
    
    for (NSIndexPath*index in list) {
        //行
        NSInteger row = index.row;
        //列
        NSInteger line = index.section;
        UIImageView*image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下一步提示"]];
        image.frame = CGRectMake(line * self.rowWidth - (15)/2.0+1, row * ((boardHeight)/6) - 15/2.0+1, 15, 15);
        [self insertSubview:image atIndex:0];
    }
}
@end
