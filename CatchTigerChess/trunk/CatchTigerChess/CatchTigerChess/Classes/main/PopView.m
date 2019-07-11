//
//  PopView.m
//  JuZhanGame
//
//  Created by zhizhuCon on 2019/3/22.
//  Copyright © 2019 ccc. All rights reserved.

#import "PopView.h"
@interface PopView()

@property (nonatomic, copy) okButtonBlock completion;

@end

@implementation PopView{
    UILabel*titleLabel ;
    UIImageView*backView;
}
+(PopView *)sharedInstance{
    static PopView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PopView alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)creatSubViews{
    backView = [[UIImageView alloc]init];
    backView.center = self.center;
    backView.bounds = CGRectMake(0, 0, 300, 200);
    backView.layer.cornerRadius = 5;
    backView.clipsToBounds = YES;
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"内购弹框"];
    [self addSubview:backView];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:2.0/255.0 green:32.0/255.0  blue:59.0/255.0  alpha:1];
    titleLabel.frame = CGRectMake((backView.frame.size.width-230)/2, 60, 230, 50);
    [backView addSubview:titleLabel];
    
    UIButton*okBtn =[self createFrame:CGRectMake(backView.frame.size.width
                                                  -30-100, 155,100, 40) tag:1 title:@"确定" action:@selector(okBtnAction:)];
    [backView addSubview:okBtn];
    
    UIButton*cancelBtn =[self createFrame:CGRectMake(30, 155,100, 40) tag:1 title:@"取消" action:@selector(cancelBtnAction)];
    [backView addSubview:cancelBtn];
}

-(void)showPopWithTitle:(NSString*)title supview:(UIView*)superView block:(okButtonBlock)block{
    self.frame = superView.frame;
    self.backgroundColor = [UIColor clearColor];
    [superView addSubview:self];
    [self creatSubViews];
    titleLabel.text = title;
    [self creatShowAnimation];
    _completion = block;
}

-(void)okBtnAction:(UIButton*)btn{
    [self removeFromSuperview];
    if (_completion) {
        _completion();
    }
}
-(void)cancelBtnAction{
     [self removeFromSuperview];
} 
#pragma mark 封装共有方法
- (void)creatShowAnimation{
    self.layer.position = self.center;
    self.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}
 
-(UIButton *)createFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title action:(SEL)action{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
 
// [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    return btn;
}

 
@end
