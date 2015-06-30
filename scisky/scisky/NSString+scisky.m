//
//  NSString+scisky.m
//  scisky
//
//  Created by 刘向宏 on 15/6/18.
//  Copyright © 2015年 刘向宏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "NSString+scisky.h"
#define KeyStr @"SDFL#)@F"

@implementation NSString (scisky)

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return [outputStr lowercasePercent];
}

- (NSString *)lowercasePercent{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *myByte = (Byte *)[data bytes];
    int i=0;
    int length = (int)[data length];
    while (i<[data length]){
        if (myByte[i] == '%')
        {
            i++;
            if ((myByte [i]>='A')&&(myByte [i]<='Z'))
                myByte[i]=myByte[i]-'A'+'a';
            i++;
            if ((myByte [i]>='A')&&(myByte [i]<='Z'))
                myByte[i]=myByte[i]-'A'+'a';
        }
        i++;
    }
    data = [NSData dataWithBytes:myByte length:length];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

-(NSString *)AESEncrypt{
    
    return [self encryptWithDES];
}

- (NSString *)encryptWithDES{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeAES128) ;//& ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vinitVec = (const void *) [KeyStr UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       [KeyStr UTF8String],
                       kCCKeySizeDES,
                       vinitVec,
                       [data bytes],
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    NSLog(@"%@",[[[myData description] formatData] decryptWithDES]);
    return [[myData description] formatData];
}

- (NSString *)formatData{
    NSMutableString *str=[self mutableCopy];
    NSString *rangeStr1 = @"<";
    NSString *rangeStr2 = @">";
    NSString *rangeStr3 = @" ";
    NSRange range = [str rangeOfString:rangeStr1];
    [str deleteCharactersInRange:range];
    range = [str rangeOfString:rangeStr2];
    [str deleteCharactersInRange:range];
    range = [str rangeOfString:rangeStr3];
    while (range.location != NSNotFound){
        [str deleteCharactersInRange:range];
        range = [str rangeOfString:rangeStr3];
    }
    return [str uppercaseString];
}

- (NSString *)decryptWithDES{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    char *vplainText = strdup([self UTF8String]);//calloc([self length] * sizeof(char) + 1);
    //    strcpy(vplainText, [self UTF8String]);
    char *plain = malloc([self length] / 2 *sizeof(char));
    for (int i=0;i<[self length] / 2;i++)
    {
        int a=0;
        if (vplainText[i * 2]>='A' && vplainText[i * 2]<='Z')
            a = vplainText[i * 2] - 'A' + 10;
        if (vplainText[i * 2]>='0' && vplainText[i * 2]<='9')
            a = vplainText[i * 2] - '0';
        int b=0;
        if (vplainText[i * 2 + 1]>='A' && vplainText[i * 2 + 1]<='Z')
            b = vplainText[i * 2 + 1] - 'A' + 10;
        if (vplainText[i * 2 + 1]>='0' && vplainText[i * 2 + 1]<='9')
            b = vplainText[i * 2 + 1] - '0';
        plain[i] = a * 16 + b;
    }
    free(vplainText);
    CCCryptorStatus ccStatus;
    const void *vinitVec = (const void *) [KeyStr UTF8String];
    size_t plainTextBufferSize = [data length];
    size_t bufferPtrSize = 0;
    uint8_t *bufferPtr = NULL;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       [KeyStr UTF8String],
                       kCCKeySizeDES,
                       vinitVec,
                       plain,
                       [self length] / 2,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    free(plain);
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    NSString *ret = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    return ret;
}

-(NSString *)safeString
{
    return self;
}
@end

@implementation NSData (scisky)
-(NSData *)AESEncrypt
{
    return nil;
}
@end


@implementation NSNumber (scisky)
-(NSString *)safeString
{
    return [self stringValue];
}
@end

@implementation NSNull (scisky)
-(NSString *)safeString
{
    return nil;
}
@end
