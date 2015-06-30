//
//  NSString+scisky.h
//  scisky
//
//  Created by 刘向宏 on 15/6/18.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (scisky)
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
-(NSString *)AESEncrypt;
-(NSString *)safeString;
@end

@interface NSData (scisky)
-(NSData *)AESEncrypt;
@end

@interface NSNumber (scisky)
-(NSString *)safeString;
@end

@interface NSNull (scisky)
-(NSString *)safeString;
@end