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
    self.dic = dic;
    self.labelTitle.text = StringNoNull(dic[@"customerName"]);
    
    self.labelOrderNo.text = StringNoNull(dic[@"orderCode"]);
    long time = [[dic[@"publishTime"] safeString] longLongValue];
    NSDate *birthday = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:mm"];
    NSString *databirthday = [formatter stringFromDate:birthday];
    self.labelTime.text = StringNoNull(databirthday);
    NSInteger type = [[dic[@"orderStatus"] safeString] integerValue];
    NSString *status =  type==0?@"新创建":(type == 1?@"待服务":(type==2?@"已完成":@"已取消"));
    if (type==1||type==0) {
        self.labelOrderStatus.textColor = [UIColor redColor];
        self.buttonCancel.hidden = NO;
    }
    else
    {
        self.labelOrderStatus.textColor = self.labelTime.textColor;
        self.buttonCancel.hidden = YES;
    }
    self.labelOrderStatus.text = StringNoNull(status);
    
    self.labelLocation.text = StringNoNull([dic[@"serviceDistrictString"] safeString]);
    self.labelContent.text = StringNoNull([dic[@"serviceContent"] safeString]);
    self.labelPrice.text = [NSString stringWithFormat:@"¥%.2f",[[self.dic[@"orderPrice"] safeString] doubleValue]];//StringNoNull([dic[@"orderPrice"] safeString]);
}

-(IBAction)btnCancelClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerTableViewCell:ButtonClicked:)]) {
        [self.delegate centerTableViewCell:self ButtonClicked:0];
    }
}

-(IBAction)btnSeeDetailClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerTableViewCell:ButtonClicked:)]) {
        [self.delegate centerTableViewCell:self ButtonClicked:1];
    }
}
@end
