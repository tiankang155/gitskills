//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "txkProgressHUD.h"

#define LandscapeLeft [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft
#define LandscapeRight [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight
#define LandscapeDown [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown
#define HUD_SUCC_IMG [UIImage imageNamed:@"wXL6"]
#define HUD_ERROR_IMG  [UIImage imageNamed:@"KvIa"]



@implementation txkProgressHUD

@synthesize interaction, window, background, hud, spinner, image, label;

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (txkProgressHUD *)shared
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
	static dispatch_once_t once = 0;
	static txkProgressHUD *progressHUD;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dispatch_once(&once, ^{ progressHUD = [[txkProgressHUD alloc] init]; });
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return progressHUD;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)dismiss
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[self shared] hudHide];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)show:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self shared].interaction = NO;
	[[self shared] hudMake:status image:nil spin:YES hide:NO];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)show:(NSString *)status Interaction:(BOOL)Interaction
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:nil spin:YES hide:NO];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showSuccess:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self shared].interaction = NO;
	[[self shared] hudMake:status image:HUD_SUCC_IMG spin:NO hide:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self shared].interaction = Interaction;
	[[self shared] hudMake:status image:HUD_SUCC_IMG spin:NO hide:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showError:(NSString *)status
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self shared].interaction = NO;
	[[self shared] hudMake:status image:HUD_ERROR_IMG spin:NO hide:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self shared].interaction = Interaction;
        [[self shared] hudMake:status image:HUD_ERROR_IMG spin:NO hide:YES];
    });
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)init
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
     if ([delegate respondsToSelector:@selector(window)])
    {
        window = [delegate window];
    }
    if (!window)
    {
        window = [[UIApplication sharedApplication] keyWindow];
    }
//    window.windowLevel = 10000;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	background = nil; hud = nil; spinner = nil; image = nil; label = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.alpha = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudMake:(NSString *)status image:(UIImage *)img spin:(BOOL)spin hide:(BOOL)hide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    NSLog(@"txkProgressHUD hudMake NSThread Info:%@", [NSThread currentThread]);
    
	[self hudCreate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	label.text = status;
    _tmpLabelTxt = status;
	label.hidden = (status == nil) ? YES : NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	image.image = img;
	image.hidden = (img == nil) ? YES : NO;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (spin) [spinner startAnimating]; else [spinner stopAnimating];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self hudSize];
	[self hudPosition:nil];
	[self hudShow];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (hide) [NSThread detachNewThreadSelector:@selector(timedHide) toTarget:self withObject:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudCreate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (hud == nil)
	{
		hud = [[UIToolbar alloc] initWithFrame:CGRectZero];
		hud.translucent = YES;
		hud.backgroundColor = HUD_BACKGROUND_COLOR;
		hud.layer.cornerRadius = 10;
		hud.layer.masksToBounds = YES;
		[self registerNotifications];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (hud.superview == nil)
	{
		if (interaction == NO)
		{
			background = [[UIView alloc] initWithFrame:window.frame];
			background.backgroundColor = HUD_WINDOW_COLOR;
			[window addSubview:background];
			[background addSubview:hud];
		}
		else [window addSubview:hud];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (spinner == nil)
	{
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.color = HUD_SPINNER_COLOR;
		spinner.hidesWhenStopped = YES;
	}
	if (spinner.superview == nil) [hud addSubview:spinner];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (image == nil)
	{
		image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
	}
	if (image.superview == nil) [hud addSubview:image];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (label == nil)
	{
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.font = HUD_STATUS_FONT;
		label.textColor = HUD_STATUS_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.numberOfLines = 0;
	}
	if (label.superview == nil) [hud addSubview:label];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)registerNotifications
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:)
												 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudPosition:) name:UIKeyboardDidShowNotification object:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudDestroy
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[label removeFromSuperview];		label = nil;
	[image removeFromSuperview];		image = nil;
	[spinner removeFromSuperview];		spinner = nil;
	[hud removeFromSuperview];			hud = nil;
	[background removeFromSuperview];	background = nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudSize
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGRect labelRect = CGRectZero;
	CGFloat hudWidth = 100, hudHeight = 100;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (label.text != nil)
	{
		NSDictionary *attributes = @{NSFontAttributeName:label.font};
		NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
		labelRect = [label.text boundingRectWithSize:CGSizeMake(200, 300) options:options attributes:attributes context:NULL];

		labelRect.origin.x = 12;
		labelRect.origin.y = 66;

		hudWidth = labelRect.size.width + 24;
		hudHeight = labelRect.size.height + 80;

		if (hudWidth < 100)
		{
			hudWidth = 100;
			labelRect.origin.x = 0;
			labelRect.size.width = 100;
		}
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	hud.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat imagex = hudWidth/2;
	CGFloat imagey = (label.text == nil) ? hudHeight/2 : 36;
	image.center = spinner.center = CGPointMake(imagex, imagey);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	label.frame = labelRect;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudPosition:(NSNotification *)notification
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGFloat heightKeyboard = 0;
	NSTimeInterval duration = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (notification != nil)
	{
		NSDictionary *info = [notification userInfo];
		CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		if ((notification.name == UIKeyboardWillShowNotification) || (notification.name == UIKeyboardDidShowNotification))
		{
			heightKeyboard = keyboard.size.height;
		}
	}
	else heightKeyboard = [self keyboardHeight];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect screen = [UIScreen mainScreen].bounds;
	CGPoint center = CGPointMake(screen.size.width/2, (screen.size.height-heightKeyboard)/2);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		hud.center = CGPointMake(center.x, center.y);
	} completion:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0) //ios7横屏坐标系问题
    {
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIDeviceOrientationLandscapeLeft:
            {
                hud.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
                break;
            case UIDeviceOrientationLandscapeRight:
            {
                hud.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown:
            {
                hud.transform = CGAffineTransformMakeRotation(M_PI);
            }
                break;
                
            default:
                break;
        }
    }
	if (background != nil) background.frame = window.frame;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)keyboardHeight
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//	for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
//	{
//		if ([[testWindow class] isEqual:[UIWindow class]] == NO)
//		{
//			for (UIView *possibleKeyboard in [testWindow subviews])
//			{
//				if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"])
//				{
//					return possibleKeyboard.bounds.size.height;
//				}
//				else if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"])
//				{
//					for (UIView *hostKeyboard in [possibleKeyboard subviews])
//					{
//						if ([[hostKeyboard description] hasPrefix:@"<UIInputSetHost"])
//						{
//							return hostKeyboard.frame.size.height;
//						}
//					}
//				}
//			}
//		}
//	}
	return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudShow
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (self.alpha == 0)
	{
		self.alpha = 1;

		hud.alpha = 0;
		hud.transform = CGAffineTransformScale(hud.transform, 1.4, 1.4);

		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			hud.transform = CGAffineTransformScale(hud.transform, 1/1.4, 1/1.4);
			hud.alpha = 1;
		} completion:nil];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)hudHide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (self.alpha == 1)
	{
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			hud.transform = CGAffineTransformScale(hud.transform, 0.7, 0.7);
			hud.alpha = 0;
		}
		completion:^(BOOL finished) {
			[self hudDestroy];
			self.alpha = 0;
		}];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)timedHide
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	@autoreleasepool
	{
        double length = 0.0;
        if(_tmpLabelTxt){
            length = _tmpLabelTxt.length;
        }else{
            length = 0;
        }
		NSTimeInterval sleep = length * 0.04 + 1.5;
		[NSThread sleepForTimeInterval:sleep];

		dispatch_async(dispatch_get_main_queue(), ^{
			[self hudHide];
		});
	}
}

@end
