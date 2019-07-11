//
//  ComVSperViewController.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "ComVSperViewController.h"

#import "RoleView.h"
#import "Chess.h"

@interface ComVSperViewController ()<chessBoardDelegate>
@property (nonatomic,assign) BOOL isSelectedDog;

@end

@implementation ComVSperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.board.isMachinePattern = YES;
    self.board.delegate = self;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseStatus) name:@"resetBoard" object:nil];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"iuirusj11"]) { //取不到 第一次
        [self showStudyView];
    }else{ //取到了 不是第一次
        [self chooseStatus];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"iuirusj11"];
   
}
-(void)chooseStatus{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RoleView showRolViewWithCompletion:^(NSInteger tag) {
            if (tag == 100) { // 老虎
                [SuccessFulView showSuccessFulViewWithImageName:@"老虎开始行动" completion:^{
                
                }];
                self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(电脑)等待中"];
                self.tigerTipImage.image = [UIImage imageNamed:@"老虎(玩家)正在行动"];
                self.isSelectedDog = NO;
                //老虎按钮绑定方法
                for (UIView*view in self.board.subviews) {
                    if ([view isKindOfClass:[Chess class]]) {
                        Chess*chess = (Chess*)view;
                        if (chess.color == ChessDog) {
                            chess.userInteractionEnabled = NO;
                        }
                    }
                }
                self.board.whoFirstGo = YES;
               
            }else{ //狗
                [SuccessFulView showSuccessFulViewWithImageName:@"猎人开始行动" completion:^{
                    
                }];
                self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(玩家)正在行动"];
                self.tigerTipImage.image = [UIImage imageNamed:@"老虎等待中"];
                self.isSelectedDog = YES;
                //狗按钮绑定方法
                for (UIView*view in self.board.subviews) {
                    if ([view isKindOfClass:[Chess class]]) {
                        Chess*chess = (Chess*)view;
                        if (chess.color == ChessTiger) {
                            chess.userInteractionEnabled = NO;
                        }
                    }
                }
                self.board.whoFirstGo = NO;
               
            }
        }];
    });
}
#pragma chessBoardDelegate
-(void)chessBoardWhoGo:(BOOL)whoGo{
    if (whoGo) {
        if (self.isSelectedDog == NO) { //如果选择的是老虎
            self.tigerTipImage.image = [UIImage imageNamed:@"老虎(玩家)正在行动"];
            self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(电脑)等待中"];
        }else{
            self.tigerTipImage.image = [UIImage imageNamed:@"老虎正在行动"];
            self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(玩家)等待中"];
        }

    }else{
        if (self.isSelectedDog == NO) {
            self.tigerTipImage.image = [UIImage imageNamed:@"老虎(玩)等待中"];
            self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(电脑)正在行动"];
        }else{
            self.tigerTipImage.image = [UIImage imageNamed:@"老虎等待中"];
            self.huntsmanTipImage.image = [UIImage imageNamed:@"猎人(玩家)正在行动"];
        }
        
    }
}

@end
