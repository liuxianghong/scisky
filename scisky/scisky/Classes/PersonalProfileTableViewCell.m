//
//  PersonalProfileTableViewCell.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "PersonalProfileTableViewCell.h"

@implementation PersonalProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.labelValue.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
