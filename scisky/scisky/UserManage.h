//
//  UserManage.h
//  scisky
//
//  Created by 刘向宏 on 15/7/5.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManage : NSObject
+(instancetype)sharedManager;
@property (nonatomic,strong) NSString *decs;
@property (nonatomic,strong) NSString *decsID;
@property (nonatomic,strong) NSString *deviceToken;
@end
