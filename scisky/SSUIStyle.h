//
//  SSUIStyle.h
//  scisky
//
//  Created by 刘向宏 on 15/6/9.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StringNoNill(a) a?a:@""
#define StringNoNull(a) [a length]>1?a:@" "

@interface SSUIStyle : NSObject
+(void)RoundStyle:(UIView *)view;
+(void)RoundStyle:(UIView *)view rect:(CGFloat)round;
@end
