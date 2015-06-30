//
//  RightTableViewCell.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell
{
    IBOutlet UIView *spaceView;
}
- (void)awakeFromNib {
    // Initialization code
    [SSUIStyle RoundStyle:self.labelNum rect:12.5];
    
    UIView *backSView = [[UIView alloc]initWithFrame:self.bounds];
    backSView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    self.selectedBackgroundView = backSView;
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.labelNum.backgroundColor = [UIColor whiteColor];
    spaceView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.labelNum.backgroundColor = [UIColor whiteColor];
}

@end
