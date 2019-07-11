//
//  ViewController.h
//  WZXMyDemo
//
//  Created by 田亢 on 2019/6/27.
//  Copyright © 2019 wzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chessboard.h"
@interface BaseViewController : UIViewController
@property (nonatomic,strong) Chessboard * board;
@property (nonatomic,strong) UIImageView*huntsmanTipImage;;

@property (nonatomic,strong) UIImageView*tigerTipImage;

-(void)showStudyView;


@end

