//
//  LeftTableTableViewCell.m
//  scisky
//
//  Created by 刘向宏 on 15/6/29.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "LeftTableTableViewCell.h"

@implementation LeftTableTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIView *backSView = [[UIView alloc]initWithFrame:self.bounds];
    backSView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    self.selectedBackgroundView = backSView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
