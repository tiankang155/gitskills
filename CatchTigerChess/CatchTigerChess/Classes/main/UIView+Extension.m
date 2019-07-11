//
//  UIView+Extension.m

//
//  Created by apple on 14-10-7.
 
//  说明 : 简化  x y with height 书写的分类

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
@end


@implementation UIView (CreatUI)


-(UIButton*)creatBtnWithImage:(NSString*)image seletImage:(NSString*)sName  title:(NSString*)title titleColor:(UIColor*)tColor bgColor:(UIColor*)color  isClip:(BOOL)isClip size:(CGFloat)size superView:(UIView*)view  {
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:sName] forState:(UIControlStateSelected)];
    [btn setBackgroundColor:color];
    
    if (isClip == YES) {
        btn.layer.cornerRadius = 20;
        btn.clipsToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor clearColor].CGColor;
    }
  
    [btn setTitleColor:tColor forState:0];
    [btn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:size]];
    btn.contentMode = UIViewContentModeCenter;
    [view addSubview:btn];
    return btn;
}


-(UIImageView*)creatImageViewWithName:(NSString*)name superView:(UIView*)view{
    UIImageView*image = [[UIImageView alloc]init];
    image.contentMode = UIViewContentModeScaleToFill;
    image.image = [UIImage imageNamed:name];
    image.userInteractionEnabled = YES;
    [view addSubview:image];
    return image;
    
}

-(UILabel*)creatLabelWithTitle:(NSString*)title alignment:(NSTextAlignment)alignment textColor:(UIColor*)textColor size:(CGFloat)size superView:(UIView*)view{
    UILabel*label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:@"Arial" size:size];
    label.textAlignment=alignment;
    label.textColor = textColor;
    label.text = title;
    [view addSubview:label];
    label.numberOfLines = 0;
    label.userInteractionEnabled=YES;
    return label;
}

-(UITextField*)creatTextFieldWithPlaceholder:(NSString*)placeholder textEntry:(BOOL)textEntry iconViewName:(NSString*)name superView:(UIView*)view{
    UITextField*textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    textField.borderStyle = UITextBorderStyleRoundedRect;
//  textField.sd_cornerRadius = @22;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;
    [textField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIView * userLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 45)];
    textField.leftView = userLeftView;
    textField.textColor = UIColor.grayColor;
    textField.font = [UIFont systemFontOfSize:14];
    UIImageView*imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    textField.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(20, 12.5, 20, 20);
    [userLeftView addSubview:imageView];
    textField.secureTextEntry = textEntry;
    [view addSubview:textField];
    return textField;
}

 

@end

