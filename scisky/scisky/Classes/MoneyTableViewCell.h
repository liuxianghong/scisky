//
//  MoneyTableViewCell.h
//  scisky
//
//  Created by 刘向宏 on 15/6/12.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *oredLabel;
@end
