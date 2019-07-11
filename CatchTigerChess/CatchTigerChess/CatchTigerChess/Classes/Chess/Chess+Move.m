//
//  Chess+Move.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "Chess+Move.h"
#import "Chessboard.h"
#import "SuccessFulView.h"
@implementation Chess (Move)

- (void)moveToIndex:(NSIndexPath *)index completion:(void (^)())completion {
    Chessboard *board = [Chessboard sharedChessboard];
     
    [UIView animateWithDuration:0.5 animations:^{
        NSInteger  row = index.row;
        NSInteger  line = index.section;
        self.frame = CGRectMake(line * self.rowWidth - (btnWidth)/2.0 , row * ((boardHeight)/6) - (btnWidth)/2.0 , btnWidth, btnWidth);
        }completion:^(BOOL finished){
            self.isInAir = NO;
            self.categoryLabel.backgroundColor = [UIColor whiteColor];
            self.index = index;
            
            if (board.whoFirstGo == YES) {
               //检测老虎是否胜利
               board.tigerChess = self;
               [self eatChessWithIndex:self.index];
            }else{
               [self checkDogIswin];
            }
            board.selectedChess = nil;
            board.whoFirstGo = !board.whoFirstGo;
            if (completion) {
               completion();
            }
            //人机模式
            if (board.isMachinePattern == YES) {
                if (self.color == ChessTiger) {
//                  if (self.isTigerWin == NO) {
                   [self performSelector:@selector(dogMove) withObject:nil afterDelay:0.5];
//                  }
                }else{
                   [self performSelector:@selector(tigerMove) withObject:nil afterDelay:0.5];
                }
            }
       }];
}

-(void)dogMove{
    NSMutableArray*temList = [NSMutableArray array];
    Chessboard *board = [Chessboard sharedChessboard];
    for (Chess*chess in board.chessArr) {
        if (chess.color != ChessTiger) {
            [temList addObject:chess];
        }
    }
    int rand = arc4random() % temList.count;
    Chess*chess = temList[rand];
    NSMutableArray*canList = [self selectCanMovePositionWithIndex:chess.index];
    if (canList && canList.count > 0) {
        int canRand = arc4random() % canList.count;
        NSIndexPath*index = canList[canRand];
        [UIView animateWithDuration:0.5 animations:^{
            NSInteger  row = index.row;
            NSInteger  line = index.section;
            chess.frame = CGRectMake(line * self.rowWidth - (btnWidth)/2.0 , row * ((boardHeight)/6) - (btnWidth)/2.0 , btnWidth, btnWidth);
        } completion:^(BOOL finished) {
            if (finished == YES) {
                chess.isInAir = NO;
                chess.index = index;
                [self checkDogIswin];
            }
            board.selectedChess = nil;
            board.whoFirstGo = !board.whoFirstGo;
        }];
    }
}

-(void)tigerMove{
    Chessboard *board = [Chessboard sharedChessboard];
    NSMutableArray*list =  [self selectCanMovePositionWithIndex:board.tigerChess.index];
    if (list && list.count > 0) {
        int rand = arc4random() % list.count;
        NSIndexPath*index = list[rand];
        [UIView animateWithDuration:0.5 animations:^{
            NSInteger  row = index.row;
            NSInteger  line = index.section;
            board.tigerChess.frame = CGRectMake(line * self.rowWidth - (btnWidth)/2.0 , row * ((boardHeight)/6) - (btnWidth)/2.0 , btnWidth, btnWidth);
        } completion:^(BOOL finished) {
            if (finished == YES) {
                board.tigerChess.isInAir = NO;
                board.tigerChess.index = index;
                [self eatChessWithIndex:index];
            }
            board.whoFirstGo = !board.whoFirstGo;
        }];
    }
}
//老虎吃子
-(void)eatChessWithIndex:(NSIndexPath*)index{
    Chessboard *board = [Chessboard sharedChessboard];
    NSInteger  fromRow = index.row;
    NSInteger  fromLine = index.section;
    if (fromRow == 0 && fromLine == 2) {
        [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
            [board resetBoardChessPosition];
        }];
        return;
    }
    //左 line-1
    NSIndexPath*left = [NSIndexPath indexPathForRow:fromRow inSection:fromLine-1];
    //右 line+1
    NSIndexPath*right = [NSIndexPath indexPathForRow:fromRow inSection:fromLine+1];
    //上 row-1
    NSIndexPath*up = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine];
    //下 row+1
    NSIndexPath*down = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine];
    //左上 row-1 line-1
    NSIndexPath*leftUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine-1];
    //右上 row-1 line+1
    NSIndexPath*rightUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine+1];
    //左下 row+1 line-1
    NSIndexPath*leftDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine-1];
    //右下 row+1 line+1
    NSIndexPath*rightDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine+1];
    
    if (self.index.row == 1 && self.index.section == 1) {
        return;
    }else if (self.index.row == 1 && self.index.section == 3) {
        return;
    }else if (self.index.row == 1 && self.index.section == 2) { //只检测左右
        if ([board chessIsExist:left] && [board chessIsExist:right]) {
            [self removeChessWithIndex1:left index2:right];
        }
        
    }else if (self.index.section== 0 || self.index.section == 4) { //只检测上下
        if ([board chessIsExist:up] && [board chessIsExist:down]) {
            [self removeChessWithIndex1:up index2:down];
        }
    }else if(self.index.row == 6){ //只检测左右
        if (self.index.section == 0) {
            return;
        }
        if (self.index.section == 4) {
            return;
        }
        if ([board chessIsExist:left] && [board chessIsExist:right]) {
            [self removeChessWithIndex1:left index2:right];
        }
        
    }else if (self.index.row == 2) { //只检测左右
        if (self.index.section == 0) {
            return;
        }
        if (self.index.section == 4) {
            return;
        }
        if ([board chessIsExist:left] && [board chessIsExist:right]) {
            [self removeChessWithIndex1:left index2:right];
        }
    }else{
        if ([board chessIsExist:left] && [board chessIsExist:right]) {
//            NSLog(@"左右两边存在");
            [self removeChessWithIndex1:left index2:right];
        }
        if ([board chessIsExist:up] && [board chessIsExist:down]) {
//            NSLog(@"上下两边存在");
            [self removeChessWithIndex1:up index2:down];
        }
        if ([board chessIsExist:leftUp] && [board chessIsExist:rightDown]) {
//            NSLog(@"左上,右下两边存在");
            [self removeChessWithIndex1:leftUp index2:rightDown];
        }
        if ([board chessIsExist:rightUp] && [board chessIsExist:leftDown]) {
//            NSLog(@"右上,左下两边存在");
            [self removeChessWithIndex1:rightUp index2:leftDown];
        }
    }
    
}
//老虎吃子
-(void)removeChessWithIndex1:(NSIndexPath*)index1 index2:(NSIndexPath*)index2{
    Chessboard *board = [Chessboard sharedChessboard];
    Chess*chess1 = [board chessIsExist:index1];
    Chess*chess2 = [board chessIsExist:index2];
    
    [chess1 removeFromSuperview];
    [chess2 removeFromSuperview];
    [board.chessArr removeObject:chess1];
    [board.chessArr removeObject:chess2];
   
    if (board.chessArr.count <= 5) {
        self.isTigerWin = YES;
        [SuccessFulView showSuccessFulViewWithImageName:@"老虎胜利" completion:^{
            [board resetBoardChessPosition];
           
        }];
       
    }
}
-(void)checkDogIswin{
    Chessboard *board = [Chessboard sharedChessboard];
    NSInteger  fromRow = board.tigerChess.index.row;
    NSInteger  fromLine = board.tigerChess.index.section;
    //左 line-1
    NSIndexPath*left = [NSIndexPath indexPathForRow:fromRow inSection:fromLine-1];
    
    //右 line+1
    NSIndexPath*right = [NSIndexPath indexPathForRow:fromRow inSection:fromLine+1];
    
    //上 row-1
    NSIndexPath*up = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine];
    
    //下 row+1
    NSIndexPath*down = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine];
    
    //左上 row-1 line-1
    NSIndexPath*leftUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine-1];
    
    //右上 row-1 line+1
    NSIndexPath*rightUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine+1];
    
    //左下 row+1 line-1
    NSIndexPath*leftDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine-1];
    
    //右下 row+1 line+1
    NSIndexPath*rightDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine+1];
    
    if (fromLine == 0 ) {
        //上  下 右 右上  右下
        if (fromRow == 2) { //下 右  右下
            if ([board chessIsExist:down] && [board chessIsExist:right] && [board chessIsExist:rightDown]) {
                [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                    [board resetBoardChessPosition];
                }];
            }
            
        }
        if (fromRow == 6) {  //上 右  右上
            if ([board chessIsExist:up] && [board chessIsExist:right] && [board chessIsExist:rightUp]) {
                [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                    [board resetBoardChessPosition];
                }];
            }
        }
        if ([board chessIsExist:up] && [board chessIsExist:right]&& [board chessIsExist:down] && [board chessIsExist:rightUp]&& [board chessIsExist:rightDown]) {
            [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                [board resetBoardChessPosition];
            }];
        }
    }else if (fromLine == 4) {
        //上  下 左 左上  左下
        if (fromRow == 2) { //下 左  左下
            if ([board chessIsExist:down] && [board chessIsExist:left] && [board chessIsExist:leftDown]) {
                [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                    [board resetBoardChessPosition];
                }];
            }
        }
        if (fromRow == 6) { //上 左  左上
            if ([board chessIsExist:up] && [board chessIsExist:left] && [board chessIsExist:leftUp]) {
                [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                    [board resetBoardChessPosition];
                }];
            }
        }
        if ([board chessIsExist:up] && [board chessIsExist:left]&& [board chessIsExist:down] && [board chessIsExist:leftUp]&& [board chessIsExist:leftDown]) {
            [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                [board resetBoardChessPosition];
            }];
        }
    }else if (fromRow == 6) {
        //上  左 右 左上  右上
        if ([board chessIsExist:up] && [board chessIsExist:left]&& [board chessIsExist:right] && [board chessIsExist:leftUp]&& [board chessIsExist:rightUp]) {
            [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                [board resetBoardChessPosition];
            }];
        }
        
    }else if (fromRow == 2) {
        //下 左 右 左下 右下
        if ([board chessIsExist:down] && [board chessIsExist:left]&& [board chessIsExist:right] && [board chessIsExist:leftDown]&& [board chessIsExist:rightDown]) {
            [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
                [board resetBoardChessPosition];
            }];
        }
    }else if([board chessIsExist:left]     &&
        [board chessIsExist:right]    &&
        [board chessIsExist:up]       &&
        [board chessIsExist:down]     &&
        [board chessIsExist:leftUp]   &&
        [board chessIsExist:rightDown]&&
        [board chessIsExist:rightUp]  &&
        [board chessIsExist:leftDown]) {
        [SuccessFulView showSuccessFulViewWithImageName:@"猎人胜利" completion:^{
            [board resetBoardChessPosition];
        }];
        
    }
}
 


-(NSMutableArray*)selectCanMovePositionWithIndex:(NSIndexPath*)index{
    Chessboard *board = [Chessboard sharedChessboard];
    NSInteger  fromRow = index.row;
    NSInteger  fromLine = index.section;
    //左 line-1
    NSIndexPath*left = [NSIndexPath indexPathForRow:fromRow inSection:fromLine-1];
    //右 line+1
    NSIndexPath*right = [NSIndexPath indexPathForRow:fromRow inSection:fromLine+1];
    //上 row-1
    NSIndexPath*up = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine];
    //下 row+1
    NSIndexPath*down = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine];
    //左上 row-1 line-1
    NSIndexPath*leftUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine-1];
    //右上 row-1 line+1
    NSIndexPath*rightUp = [NSIndexPath indexPathForRow:fromRow-1 inSection:fromLine+1];
    //左下 row+1 line-1
    NSIndexPath*leftDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine-1];
    //右下 row+1 line+1
    NSIndexPath*rightDown = [NSIndexPath indexPathForRow:fromRow+1 inSection:fromLine+1];
    
    NSMutableArray*temList = [NSMutableArray array];
    if (fromRow == 0) {
        if (fromLine == 2) { //下 左下 右下
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject: rightDown];
            }
        }
    }else if (fromRow == 1) {
        if (fromLine == 1) { // 右 右上 右下
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:rightUp]) {
                [temList addObject:rightUp];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject:rightDown];
            }
        }else if (fromLine == 2) { //上 下 左 右
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
        }else if (fromLine == 3) { // 左 左上 左下
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:leftUp]) {
                [temList addObject:leftUp];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
        }
    }else if (fromRow == 2) {
        if (fromLine == 0) { //右 下 右下
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject:rightDown];
            }
        }else if (fromLine == 4) { //左 下 左下
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
        }else if (fromLine == 2) { // 上 左 右 下 左下  右下
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject:rightDown];
            }
            if (![board chessIsExist:leftUp]) {
                [temList addObject:leftUp];
            }
            if (![board chessIsExist:rightUp]) {
                [temList addObject:rightUp];
            }
        }else{
             //左 右 下 左下  右下
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject:rightDown];
            }
        }
    }else if (fromLine == 0) {
        if (fromRow == 6) { // 上 右 右上
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:rightUp]) {
                [temList addObject:rightUp];
            }
        }else{
            //上 下 右 右上 右下
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:right]) {
                [temList addObject:right];
            }
            if (![board chessIsExist:rightUp]) {
                [temList addObject:rightUp];
            }
            if (![board chessIsExist:rightDown]) {
                [temList addObject:rightDown];
            }
        }
    }else if (fromLine == 4) {
        if (fromRow == 6) { //上 左 左上
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:leftUp]) {
                [temList addObject:leftUp];
            }
        }else{ //上 下 左 左上 左下
            if (![board chessIsExist:up]) {
                [temList addObject:up];
            }
            if (![board chessIsExist:down]) {
                [temList addObject:down];
            }
            if (![board chessIsExist:left]) {
                [temList addObject:left];
            }
            if (![board chessIsExist:leftUp]) {
                [temList addObject:leftUp];
            }
            if (![board chessIsExist:leftDown]) {
                [temList addObject:leftDown];
            }
        }
    }else if (fromRow == 6) {
        //左 右 上 左上 右上
        if (![board chessIsExist:left]) {
            [temList addObject:left];
        }
        if (![board chessIsExist:right]) {
            [temList addObject:right];
        }
        if (![board chessIsExist:up]) {
            [temList addObject:up];
        }
        if (![board chessIsExist:leftUp]) {
            [temList addObject:leftUp];
        }
        if (![board chessIsExist:rightUp]) {
            [temList addObject:rightUp];
        }
    }else{  //8个方向正常检测
        if (![board chessIsExist:left]) {
            [temList addObject:left];
        }
        if (![board chessIsExist:right]) {
            [temList addObject:right];
        }
        if (![board chessIsExist:up]) {
            [temList addObject:up];
        }
        if (![board chessIsExist:down]) {
            [temList addObject:down];
        }
        if (![board chessIsExist:leftUp]) {
            [temList addObject:leftUp];
        }
        if (![board chessIsExist:rightUp]) {
            [temList addObject:rightUp];
        }
        if (![board chessIsExist:leftDown]) {
            [temList addObject:leftDown];
        }
        if (![board chessIsExist:rightDown]) {
            [temList addObject:rightDown];
        }
    }
    return temList;
}


@end
