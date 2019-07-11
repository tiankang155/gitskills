//
//  PvsPViewController.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "PvsPViewController.h"

@interface PvsPViewController ()<chessBoardDelegate>

@end

@implementation PvsPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whoShouldGoFirst) name:@"resetBoard" object:nil];
    self.board.isMachinePattern = NO;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"oiunmjs11"]) { //取不到 第一次
        [self showStudyView];
    }else{ //取到了 不是第一次
        [self whoShouldGoFirst];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"oiunmjs11"];
    
    self.board.delegate = self;
}
-(void)whoShouldGoFirst{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int x = arc4random() % 2;
        if (x == 0) { //狗先走
            self.board.whoFirstGo = x;
            [SuccessFulView showSuccessFulViewWithImageName:@"猎人开始行动" completion:^{
                
            }];
            
        }else{ //老虎先走
            self.board.whoFirstGo = x;
            [SuccessFulView showSuccessFulViewWithImageName:@"老虎开始行动" completion:^{
                
            }];
        }
    });
}

#pragma chessBoardDelegate
-(void)chessBoardWhoGo:(BOOL)whoGo{
    if (whoGo) {
        self.tigerTipImage.image = [UIImage imageNamed:@"老虎(玩家)正在行动"];
        self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(玩家)等待中"];
        
        
    }else{
        self.tigerTipImage.image = [UIImage imageNamed:@"老虎(玩)等待中"];
        self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(玩家)正在行动"];
        
    }
}

@end
