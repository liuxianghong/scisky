//
//  SeverChoiceTableViewController.h
//  scisky
//
//  Created by 刘向宏 on 15/6/20.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeverChoiceModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *modelID;
@property (nonatomic) BOOL checked;
@end


@interface SeverChoiceTableViewController : UITableViewController
@property (nonatomic) NSInteger type;
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSString *cityID;
@end
