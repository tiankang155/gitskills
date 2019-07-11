//
//  LanViewController.m
//  BieNiuChess
//
//  Created by  on 2019/5/28.
//  Copyright © 2019 ccc. All rights reserved.
//

#import "LanViewController.h"
#import "PvsPViewController.h"
#import "ComVSperViewController.h"
@interface LanViewController (){
    UIImageView*_bgImageView;
    UIImageView*_logoImageView;
    UIImageView*_centerImageView;
    UIButton*_startBtn;
    UIButton*_vsBtn;
}

@end

@implementation LanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView*backImage  = [[UIImageView alloc]initWithFrame:self.view.frame];
    backImage.image = [UIImage imageNamed:@"firstBg"];
    backImage.userInteractionEnabled = YES;
    _bgImageView = backImage;
    backImage.backgroundColor = [UIColor grayColor];
    [self.view addSubview:backImage];
    
    _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-280)/2, 120, 280, 150)];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoImageView];
     
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _centerImageView.center = self.view.center;
    _centerImageView.image = [UIImage imageNamed:@"hu"];
    [self.view addSubview:_centerImageView];
    
    
    _startBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_startBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, self.view.frame.size.height-180, 140, 50)];
    [_startBtn setImage:[UIImage imageNamed:@"玩家对战"] forState:(UIControlStateNormal)];
    [_startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _startBtn.tag = 1;
    [_bgImageView addSubview:_startBtn];
    
    _vsBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_vsBtn setFrame:CGRectMake((self.view.frame.size.width-140)/2, self.view.frame.size.height-110, 140, 50)];
    [_vsBtn setImage:[UIImage imageNamed:@"电脑对战"] forState:(UIControlStateNormal)];
    [_vsBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bgImageView addSubview:_vsBtn];

}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)startBtnAction:(UIButton*)btn{
    UIViewController*vc;
    if (btn.tag == 1) {
        PvsPViewController*fightVC = [[PvsPViewController alloc]init];
        vc = fightVC;
    }else{
      ComVSperViewController*gameVc = [[ComVSperViewController alloc]init];
      vc = gameVc;
    }
    [UIView transitionFromView:self.view toView:vc.view duration:0.9 options:(UIViewAnimationOptionTransitionFlipFromLeft) completion:^(BOOL finished) {
        UIWindow*window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = vc;
    }];
}
@end
