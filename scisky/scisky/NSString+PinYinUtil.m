//
//  NSString+PinYinUtil.m
//  DoctorFei_iOS
//
//  Created by shadowPriest on 4/20/15.
//
//

#import "NSString+PinYinUtil.h"
@implementation NSString (PinYinUtil)
- (NSString *)getFirstCharPinYin {

    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFMutableStringRef)[NSMutableString stringWithString:self]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSMutableString *aNSString = (__bridge NSMutableString *)string;
    NSString *finalString = [aNSString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
    
    NSLog(@"%@", finalString);
    if ([finalString canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return [[NSString stringWithFormat:@"%c",[finalString characterAtIndex:0]] uppercaseString];
    }
    return @"#";
}
@end
