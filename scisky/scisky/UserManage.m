//
//  UserManage.m
//  scisky
//
//  Created by 刘向宏 on 15/7/5.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "UserManage.h"

@implementation UserManage
+(instancetype)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
@end
