//
//  Chessboard.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//
#import "Map.h"

@class Chess;
@protocol chessBoardDelegate <NSObject>

-(void)chessBoardWhoGo:(BOOL)whoGo;

@end

@interface Chessboard : Map

singleton_interface(Chessboard)
@property (nonatomic,weak) id<chessBoardDelegate> delegate;
@property (nonatomic, strong) Chess *selectedChess;
@property (nonatomic, strong) Chess *tigerChess;
@property (nonatomic, strong) NSMutableArray<Chess *> *chessArr;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *canMoveList;
@property (nonatomic,assign) BOOL isMachinePattern;  //是否是人机模式


/**
 谁先走
 */
@property (nonatomic,assign) BOOL whoFirstGo;

-(Chess*)chessOnRow:(NSInteger)row section:(NSInteger)section;
-(Chess*)chessIsExist:(NSIndexPath*)index;

- (void)initChessboard;

- (void)moveIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex;
-(void)resetBoardChessPosition;

@end
