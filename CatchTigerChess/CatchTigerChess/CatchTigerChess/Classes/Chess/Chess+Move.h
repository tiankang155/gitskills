//
//  Chess+Move.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "Chess.h"

@interface Chess (Move)

- (void)moveToIndex:(NSIndexPath *)index completion:(void (^)())completion;

//查找能走的位置
-(NSMutableArray*)selectCanMovePositionWithIndex:(NSIndexPath*)index;
@end
