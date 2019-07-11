//
//  ViewController.m
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import "BaseViewController.h"
#import "LanViewController.h"
#import "Chess.h"
#import "TXKIAPMgr.h"
#import "Chess+Move.h"
#import "txkProgressHUD.h"
@interface BaseViewController (){
    UIImageView*_bgImageView;
    UIImageView*_navImageView;
    UIButton*_mainBtn;
    UIButton*_refBtn;
    UIButton*_helpBtn;
    UIButton*_removeAdsBtn;
    UIButton*_buyBtn;
    UIView*_bgView;
    UIView*_studyView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
}

-(void)showStudyView{
    _studyView = [[UIView alloc]initWithFrame:self.view.frame];
//    UITapGestureRecognizer*tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)];
//    [_studyView addGestureRecognizer:tapGes];
    [self.view addSubview:_studyView];
    _studyView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    //如果是第一次进入该页面
    UIImageView*coverImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"引导手指"]];
    coverImage.frame = CGRectMake((self.view.width-(boardWidth+20))/2+5, 150+boardHeight, 50, 50);
    [_studyView addSubview:coverImage];
    UIImageView*greenImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下一步提示"]];
    greenImage.frame = CGRectMake(1 * (boardWidth/4.0) - (15)/2.0+1, 5 * ((boardHeight)/6) - 15/2.0+1, 15, 15);
    [self.board insertSubview:greenImage atIndex:0];
    
    //加一个手指
    CABasicAnimation *panimation = [CABasicAnimation animation];
    coverImage.layer.anchorPoint = CGPointMake(0, 0);
    panimation.keyPath = @"position";
    panimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(coverImage.x-25, coverImage.y-25)];
    panimation.toValue =[NSValue valueWithCGPoint:CGPointMake((self.view.width-(boardWidth+20))/2+5+(boardWidth/4.0), 150+boardHeight-((boardHeight)/6))];
    
    panimation.duration = 2;
    panimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    panimation.repeatCount = HUGE_VALF;
    [coverImage.layer addAnimation:panimation forKey:@"basic"];
 
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Chess*chess = self.board.chessArr[12];
            [UIView animateWithDuration:1 animations:^{
                NSIndexPath*index = [NSIndexPath indexPathForRow:5 inSection:1];
                NSInteger  row = index.row;
                NSInteger  line = index.section;
                chess.frame = CGRectMake(line * (boardWidth/4.0) - (btnWidth)/2.0 , row * ((boardHeight)/6) - (btnWidth)/2.0 , btnWidth, btnWidth);
            } completion:^(BOOL finished) {
                [self tapGes];
            }];
      });
}
-(void)tapGes{
    [_studyView removeFromSuperview];
    [self.board resetBoardChessPosition];
}
-(void)creatSubViews{
    _bgImageView = [self.view creatImageViewWithName:@"g_bg" superView:self.view];
    _bgImageView.frame = self.view.frame;
    
    _navImageView = [self.view creatImageViewWithName:@"dbu" superView:_bgImageView];
    _navImageView.frame = CGRectMake(0,0, SCREEN_W, NAVHEIGHT);
    
    _mainBtn = [self.view creatBtnWithImage:@"zy" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:10 superView:_navImageView];
    _mainBtn.frame = CGRectMake(15, StatusBarHeight, 35, 35);
    [_mainBtn addTarget:self action:@selector(mainBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _helpBtn = [self.view creatBtnWithImage:@"help" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:10 superView:_navImageView];
    _helpBtn.frame = CGRectMake(_mainBtn.x+35+10, _mainBtn.y, 35, 35);
    [_helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    _helpBtn = [self.view creatBtnWithImage:@"help" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:10 superView:_navImageView];
//    _helpBtn.frame = CGRectMake(_refBtn.x+35+10, _mainBtn.y, 35, 35);
//    [_helpBtn addTarget:self action:@selector(helpBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _buyBtn = [self.view creatBtnWithImage:@"hhgm" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:10 superView:_navImageView];
    _buyBtn.frame = CGRectMake(_navImageView.width-35-15, _mainBtn.y, 35, 35);
    [_buyBtn addTarget:self action:@selector(buyBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _removeAdsBtn = [self.view creatBtnWithImage:@"qcgg" seletImage:@"" title:@"" titleColor:nil bgColor:nil isClip:NO size:10 superView:_navImageView];
    _removeAdsBtn.frame = CGRectMake(_buyBtn.x-10-35, _mainBtn.y, 35, 35);
    [_removeAdsBtn addTarget:self action:@selector(removeAdsBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _huntsmanTipImage = [self.view creatImageViewWithName:@"猎人(玩家)等待中" superView:_bgImageView];
    _huntsmanTipImage.frame = CGRectMake(30, _navImageView.height+50, 90, 45);
    _tigerTipImage = [self.view creatImageViewWithName:@"老虎(玩)等待中" superView:_bgImageView];
    _tigerTipImage.frame = CGRectMake(_bgImageView.width-30-90, _navImageView.height+50, 90, 45);
    
    UIImageView*gameImageView = [self.view creatImageViewWithName:@"棋盘" superView:self.view];
    gameImageView.frame = CGRectMake((self.view.width-(boardWidth+20))/2, 150, boardWidth+20, boardHeight+20);
    
    UIImageView*trapImageView = [self.view creatImageViewWithName:@"陷阱" superView:gameImageView];
    trapImageView.userInteractionEnabled = NO;
    trapImageView.frame = CGRectMake((boardWidth+20)/2-25, -30, 50, 60);
    
    _board = [[Chessboard alloc]initWithStartPt:CGPointMake(10, 2) andRowWidth:boardWidth/4.0];
    [_board initChessboard];
    [gameImageView addSubview:_board];
}

#pragma -mark 导航相关按钮
-(void)mainBtnAction:(UIButton*)btn{
    LanViewController*Vc= [[LanViewController alloc]init];
    [UIView transitionFromView:self.view toView:Vc.view duration:1 options:(UIViewAnimationOptionTransitionFlipFromRight) completion:^(BOOL finished) {
        UIWindow*window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = Vc;
    }];
}
//-(void)refBtnAction:(UIButton*)btn{
//
//}
-(void)helpBtnAction:(UIButton*)btn{
    _bgView = [[UIView alloc]initWithFrame:self.view.frame];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_bgView];
    UIImageView*helpImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"规则"]];
    helpImageView.center = self.view.center;
    helpImageView.bounds = CGRectMake(0, 0,320, 450);
    [_bgView addSubview:helpImageView];
    
    UIButton*closeBtn = [self.view creatBtnWithImage:@"" seletImage:@"" title:@"" titleColor:nil bgColor:[UIColor clearColor] isClip:NO size:10 superView:_bgView];
    closeBtn.frame = CGRectMake(helpImageView.x+250, helpImageView.y+20, 40, 40);
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)closeBtnAction{
    [_bgView removeFromSuperview];
}

-(void)buyBtnAction:(UIButton*)btn{
    [[PopView sharedInstance]showPopWithTitle:@"想要花费6元恢复购买吗?" supview:self.view block:^{
        [[TXKIAPMgr sharedInstance] reqProductWithProID:@"" extInfo:@"" result:^(BOOL isSuccessed) {
            if (isSuccessed == YES) {
                [txkProgressHUD showSuccess:@"购买成功" Interaction:YES];
            }else{
                [txkProgressHUD showError:@"购买失败" Interaction:YES];
                
            }
        }];
    }];
}
-(void)removeAdsBtnAction:(UIButton*)btn{
    [[PopView sharedInstance]showPopWithTitle:@"想要花费6元去除广告吗?" supview:self.view block:^{
            [[TXKIAPMgr sharedInstance] reqProductWithProID:@"" extInfo:@"" result:^(BOOL isSuccessed) {
                if (isSuccessed == YES) {
                    [txkProgressHUD showSuccess:@"购买成功" Interaction:YES];
                }else{
                    [txkProgressHUD showError:@"购买失败" Interaction:YES];
                }
            }];
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (UIView*view in _board.subviews) {
        if ([view isKindOfClass:[Chess class]] || [view isKindOfClass:[UIImageView class]]) {
            Chess*chess = (Chess*)view;
            UIImageView*image = (UIImageView*)view;
            [chess removeFromSuperview];
            [image removeFromSuperview];
        }
    }
    
}

@end
