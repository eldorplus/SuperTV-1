//
//  SHUtility.h
//  SohuNews2
//  常用函数集合
//  Created by Chen Zhiqiang on 13-8-5.
//  Copyright (c) 2013年 Chen Zhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUtility : NSObject
+ (BOOL)isEmptyString:(NSString *)string;
+ (NSString *)md5Hash:(NSString *)content;
+ (NSString *)requestAESStringWithUserID:(NSString *)uid AESKey:(NSString *)key;
+ (NSString *)stringTrimming:(NSString *)str;
+ (NSString *)getLinkFromShareContent:(NSString *)content;
+ (UIImage *)imageWithPath:(NSString *) imagePath;
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)imageWithName:(NSString *)name ofType:(NSString *)type;
+ (UIImage *)imageAdjustedWithName:(NSString *)name ofType:(NSString *)type;
+ (NSString*)getCFUUID;

+(void)drawVoteSeperateDashLine:(CGRect)bounds margin:(float)margin;
+(void)drawVoteSeperateSolidLine:(CGRect)bounds margin:(float)margin;

+ (UIColor*)colorWithRgbHexString:(NSString*)hexString;
+ (CGRect)calculateFrameToFitScreenBySize:(CGSize)size;
+ (NSString*)urlEncoded:(NSString*)strTxt;

+ (NSString *)formatRelativeTime:(NSDate *)date;
+ (NSDate*)convertDateFromString:(NSString *)strDate;
+ (NSString *)weekdayForDate:(NSDate *)date;

@end


@interface UIImage (SNImage)

+ (NSString *)screenshotImagePathFromView:(UIView*)view;

@end

#pragma mark - AES Encrypt/Decrypt (Optional)
@interface NSData (AES256)
+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain AESKey:(NSString *)aeskey;        /*加密方法,参数需要加密的内容*/
+ (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts  AESKey:(NSString *)aeskey; /*解密方法，参数数密文*/

- (NSString *)base64Encoding;

@end

#pragma mark - AES Encrypt/Decrypt (Basic)
@interface NSData (AESAdditions)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end

@interface NSString (AESAdditions)
- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;
@end
