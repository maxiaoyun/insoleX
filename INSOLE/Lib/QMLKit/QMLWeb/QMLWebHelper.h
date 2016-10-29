//
//  QMLWebHelper.h
//  testQMLKit
//
//  Created by Myron on 15/4/24.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import "QMLDefine.h"

@interface QMLWebHelper : QMLObj
+(void)saveLastModifyDate:(NSString *)lastModifyDate forRequest:(NSURLRequest*)request;
+(NSString *)lastModifyDateForRequest:(NSURLRequest*)request;
+(void)shouldLoadRequest:(NSURLRequest *)request callback:(VBBlock)callback;
@end
