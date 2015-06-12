//
//  SSUIStyle.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "SSUIStyle.h"

@implementation SSUIStyle
+(void)RoundStyle:(UIView *)view
{
    view.layer.cornerRadius = view.height/2;
    view.layer.borderWidth = 0;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.layer.masksToBounds = YES;
}

+(void)RoundStyle:(UIView *)view rect:(CGFloat)round
{
    view.layer.cornerRadius = round;
    view.layer.borderWidth = 0;
    view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.layer.masksToBounds = YES;
}

+(void)ViewaddGestureRecognizer:(UIView *)view WithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGestureRecognizer.cancelsTouchesInView = YES;
    [view addGestureRecognizer:tapGestureRecognizer];
}

+(void)ButtonAttributedTitle:(UIButton *)btn title:(NSString *)str
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    btn.titleLabel.attributedText = content;
}

+(void)LabelAttributedTitle:(UILabel *)label title:(NSString *)str
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    label.attributedText = content;
}
@end
