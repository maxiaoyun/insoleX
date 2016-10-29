//
//  QMLUnit.h
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//


#import "QMLObj.h"

typedef enum : NSUInteger {
    UBCPlatformUndefine = 1,
    UBCPlatformI4,
    UBCPlatformI5,
    UBCPlatformI6,
    UBCPlatformI6Plus,
} UBCPlatform;

@class NSString,UITextView,QMLView;
@interface QMLUnit : QMLObj
+(UBCPlatform)currentPlatform;
+(NSString *)md5:(NSString *)oriString;
/**
 *	@brief	去除字符串的空格和换行
 *
 *	@param 	str 	要处理的字符串
 *
 *	@return 去除空格和换行的字符串
 */
+(NSString *)stringByDelWhitespaceAndNewLine:(NSString *)str;

/**
 *	@brief	判断是否为有值的字符串（非字符串或者只包含空格和换行的字符串被认为是非有值的字符串）
 *
 *	@param 	str 	需要判断的字符串
 *
 *	@return 非只包含空格和换行的字符串 返回YES，其他返回NO
 */
+ (BOOL)isValueString:(NSString *)str;

/**
 *	@brief	从类名生成实例
 *
 *	@param 	classStr 	类名
 *
 *	@return	生成的实例 有时为nil（指定的类并不存在）
 */
+(id)insFormClassStr:(NSString *)classStr;

+(void)alertMsg:(NSString *)str;

+(void)cacheObj:(id)obj forKey:(NSString *)key;
+(id)cachedObjForKey:(NSString *)key;

//mutableTextLine:(BOOL)mutableTextLine

// 默认是多行显示文字啊
+(QMLView *)createViewWithImage:(UIImage *)img
                       imgScale:(CGFloat)imgScale
                           span:(CGFloat)span
                           text:(NSAttributedString *)text
                   maxTextWidth:(CGFloat)maxTextWidth
                   textPosition:(QMLDirection)position;
+(QMLView *)createViewWithImageUrl:(NSURL *)imgUrl
                       imgSize:(CGSize)imgSize
                           span:(CGFloat)span
                           text:(NSAttributedString *)text
                   maxTextWidth:(CGFloat)maxTextWidth
                   textPosition:(QMLDirection)position;
@end
