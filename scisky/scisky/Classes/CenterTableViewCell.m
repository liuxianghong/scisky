//
//  CenterTableViewCell.m
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "CenterTableViewCell.h"

@implementation CenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)dic
{
    self.labelTitle.text = StringNoNull(dic[@"dic"]);
    
    self.labelOrderNo.text = StringNoNull(dic[@"dic"]);
    self.labelTime.text = StringNoNull(dic[@"dic"]);
    self.labelOrderStatus.text = StringNoNull(dic[@"dic"]);
    
    self.labelLocation.text = StringNoNull(dic[@"dic"]);
    self.labelContent.text = StringNoNull(dic[@"dic"]);
    self.labelPrice.text = StringNoNull(dic[@"dic"]);
}

-(IBAction)btnCancelClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerTableViewCellButtonClicked:)]) {
        [self.delegate centerTableViewCellButtonClicked:0];
    }
}

-(IBAction)btnSeeDetailClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerTableViewCellButtonClicked:)]) {
        [self.delegate centerTableViewCellButtonClicked:1];
    }
}
@end
