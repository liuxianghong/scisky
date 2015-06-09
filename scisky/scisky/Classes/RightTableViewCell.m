//
//  RightTableViewCell.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [SSUIStyle RoundStyle:self.labelNum rect:12.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
