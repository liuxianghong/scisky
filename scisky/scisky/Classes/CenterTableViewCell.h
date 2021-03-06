//
//  CenterTableViewCell.h
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CenterTableViewCell;
@protocol centerTableViewCellDelegate<NSObject>
-(void)centerTableViewCell:(CenterTableViewCell *)cell ButtonClicked:(NSInteger)index;
@end


@interface CenterTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *labelTitle;

@property (nonatomic,weak) IBOutlet UILabel *labelOrderNo;
@property (nonatomic,weak) IBOutlet UILabel *labelTime;
@property (nonatomic,weak) IBOutlet UILabel *labelOrderStatus;

@property (nonatomic,weak) IBOutlet UILabel *labelLocation;
@property (nonatomic,weak) IBOutlet UILabel *labelContent;
@property (nonatomic,weak) IBOutlet UILabel *labelPrice;

@property (nonatomic,weak) IBOutlet UIButton *buttonCancel;
@property (nonatomic,weak) IBOutlet UIButton *buttonSee;

@property (nonatomic,strong) NSMutableDictionary *dic;

@property (nonatomic,weak) IBOutlet id<centerTableViewCellDelegate> delegate;

-(void)setData:(NSMutableDictionary *)dic;
@end
