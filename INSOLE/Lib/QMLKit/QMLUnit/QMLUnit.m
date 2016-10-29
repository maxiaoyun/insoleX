//
//  QMLUnit.m
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLUnit.h"
#import "QMLKit.h"
#import "QMLAlertView.h"
#import <CommonCrypto/CommonDigest.h>

@implementation QMLUnit
static UBCPlatform s_currenrPlatform = 0;
+(UBCPlatform)currentPlatform{
    if (s_currenrPlatform==0) {
        int h = [[UIScreen mainScreen] bounds].size.height;
        switch (h) {
            case 480:
                s_currenrPlatform = UBCPlatformI4;
                break;
            case 568:
                s_currenrPlatform = UBCPlatformI5;
                break;
            case 667:
                s_currenrPlatform = UBCPlatformI6;
                break;
            case 736:
                s_currenrPlatform = UBCPlatformI6Plus;
                break;
                
            default:
                s_currenrPlatform = UBCPlatformUndefine;
                break;
        }
    }
    return s_currenrPlatform;
}
+(NSString *)md5:(NSString *)oriString {
    if (!oriString) {
        return nil;
    }
    const char *original_str = [oriString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
+(NSString *)stringByDelWhitespaceAndNewLine:(NSString *)str{
    if ([str isKindOfClass:[NSString class]]) {
        NSMutableString *string=[NSMutableString stringWithString:str];
        [string replaceOccurrencesOfString:@"\r\n" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
        [string replaceOccurrencesOfString:@"\n" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
        [string replaceOccurrencesOfString:@"" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
        return string;
    }
    return @"";
}
+ (BOOL)isValueString:(NSString *)str
{
    if (![str isKindOfClass:[NSString class]]) return NO;
    NSMutableString *muStr=[str mutableCopy];
    [muStr replaceOccurrencesOfString:@"\r\n" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, muStr.length)];
    [muStr replaceOccurrencesOfString:@"" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, muStr.length)];
    [muStr replaceOccurrencesOfString:@"" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, muStr.length)];
    return ![muStr isEqualToString:@""];
}
+(id)insFormClassStr:(NSString *)classStr
{
#if __has_feature(objc_arc)
    id ins= [[NSClassFromString(classStr) alloc] init];
#else
    id ins= [[[NSClassFromString(classStr) alloc] init] autorelease];
#endif
    return ins;
}

+(void)alertMsg:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"QMLAlert" message:str delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [al show];
}


static NSCache *s_cache_ = nil;
+(void)cacheObj:(id)obj forKey:(NSString *)key{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!key||!obj) {
            return;
        }
        if (!s_cache_) {
            s_cache_ = [[NSCache alloc] init];
        }
        [s_cache_ setObject:obj forKey:key];
    });
    
}
+(id)cachedObjForKey:(NSString *)key{
    return [s_cache_ objectForKey:key];
}

+(QMLView *)createViewWithImage:(UIImage *)img
                       imgScale:(CGFloat)imgScale
                           span:(CGFloat)span
                           text:(NSAttributedString *)text
                   maxTextWidth:(CGFloat)maxTextWidth
                   textPosition:(QMLDirection)position
{
    QMLView *view = [[QMLView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor clearColor];
    
    float i_w = CGImageGetWidth(img.CGImage)*imgScale;
    float i_h = CGImageGetHeight(img.CGImage)*imgScale;
    
    QMLImageView *im = [[QMLImageView alloc] initWithFrame:CGRectMake(0, 0, i_w, i_h)];
    im.image = img;
    im.tag = 1;
    [view addSubview:im];
    
    int numOfLen = 0;
    
    if (maxTextWidth==0) {
        maxTextWidth = CGFLOAT_MAX;
        numOfLen = 1;
    }
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxTextWidth, 10)];
    la.attributedText = text;
    la.tag = 2;
    la.numberOfLines = numOfLen;
    la.backgroundColor = [UIColor clearColor];
    la.userInteractionEnabled = NO;
    la.textAlignment = NSTextAlignmentCenter;
    CGSize size = [la sizeThatFits:CGSizeMake(maxTextWidth, CGFLOAT_MAX)];
    float l_w = size.width;
    float l_h = size.height;
    la.frame = CGRectMake(0, 0, l_w, l_h);
    [view addSubview:la];
    
    float w = 0;
    float h = 0;
    
    if (i_h==0) {
        span = 0;
    }
    
    switch (position) {
        case QMLDirectionUp:
        {
            w = MAX(l_w, i_w);
            h = i_h + l_h + span;
            
            float i_y = l_h + span;
            im.frame = CGRectMake(0, i_y, i_w, i_h);
            
            im.center = CGPointMake(w/2, im.center.y);
            la.center = CGPointMake(w/2, la.center.y);
        }
            break;
        case QMLDirectionRight:
        {
            w = i_w + span + l_w;
            h = MAX(i_h, l_h);
            
            float l_x = i_w + span;
            la.frame = CGRectMake(l_x, 0, l_w, l_h);
            
            im.center = CGPointMake(im.center.x, h/2);
            la.center = CGPointMake(la.center.x, h/2);
        }
            break;
        case QMLDirectionDown:
        {
            w = MAX(l_w, i_w);
            h = i_h + l_h + span;
            
            float l_y = i_h + span;
            la.frame = CGRectMake(0, l_y, l_w, l_h);
            
            im.center = CGPointMake(w/2, im.center.y);
            la.center = CGPointMake(w/2, la.center.y);
        }
            break;
        case QMLDirectionLeft:
        {
            w = i_w + span + l_w;
            h = MAX(i_h, l_h);
            
            float i_x = l_w + span;
            im.frame = CGRectMake(i_x, 0, i_w, i_h);
            
            im.center = CGPointMake(im.center.x, h/2);
            la.center = CGPointMake(la.center.x, h/2);
        }
            break;
            
        default:
            break;
    }
    
    CGRect rect = view.frame;
    rect.size.width  = w;
    rect.size.height = h;
    view.frame = rect;
    
    return view;
}
+(QMLView *)createViewWithImageUrl:(NSURL *)imgUrl
                           imgSize:(CGSize)imgSize
                              span:(CGFloat)span
                              text:(NSAttributedString *)text
                      maxTextWidth:(CGFloat)maxTextWidth
                      textPosition:(QMLDirection)position
{
    QMLView *view = [[QMLView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor clearColor];
    
    float i_w = imgSize.width;
    float i_h = imgSize.height;
    
    QMLImageView *im = [[QMLImageView alloc] initWithFrame:CGRectMake(0, 0, i_w, i_h)];
    im.tag = 1;
    im.backgroundColor = [UIColor clearColor];
    [view addSubview:im];
    [im loadImageWithUrl:imgUrl finish:^(UIImage *img, NSData *imgData) {
        if (img) {
            im.image = [img fitToSize:im.frame.size];
        }
    }];
    
    
    UITextView *la = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, maxTextWidth, 20)];
    la.attributedText = text;
    la.tag = 2;
    la.backgroundColor = [UIColor clearColor];
    la.userInteractionEnabled = NO;
    la.textAlignment = NSTextAlignmentCenter;
    CGSize size = [la sizeThatFits:CGSizeMake(maxTextWidth, CGFLOAT_MAX)];
    float l_w = size.width;
    float l_h = size.height;
    la.frame = CGRectMake(0, 0, l_w, l_h);
    [view addSubview:la];
    float w = 0;
    float h = 0;
    
    if (i_h==0) {
        span = 0;
    }
    
    switch (position) {
        case QMLDirectionUp:
        {
            w = MAX(l_w, i_w);
            h = i_h + l_h + span;
            
            float i_y = l_h + span;
            im.frame = CGRectMake(0, i_y, i_w, i_h);
            
            im.center = CGPointMake(w/2, im.center.y);
            la.center = CGPointMake(w/2, la.center.y);
        }
            break;
        case QMLDirectionRight:
        {
            w = i_w + span + l_w;
            h = MAX(i_h, l_h);
            
            float l_x = i_w + span;
            la.frame = CGRectMake(l_x, 0, l_w, l_h);
            
            im.center = CGPointMake(im.center.x, h/2);
            la.center = CGPointMake(la.center.x, h/2);
        }
            break;
        case QMLDirectionDown:
        {
            w = MAX(l_w, i_w);
            h = i_h + l_h + span;
            
            float l_y = i_h + span;
            la.frame = CGRectMake(0, l_y, l_w, l_h);
            
            im.center = CGPointMake(w/2, im.center.y);
            la.center = CGPointMake(w/2, la.center.y);
        }
            break;
        case QMLDirectionLeft:
        {
            w = i_w + span + l_w;
            h = MAX(i_h, l_h);
            
            float i_x = l_w + span;
            im.frame = CGRectMake(i_x, 0, i_w, i_h);
            
            im.center = CGPointMake(im.center.x, h/2);
            la.center = CGPointMake(la.center.x, h/2);
        }
            break;
            
        default:
            break;
    }
    
    CGRect rect = view.frame;
    rect.size.width  = w;
    rect.size.height = h;
    view.frame = rect;
    
    return view;
}
@end


