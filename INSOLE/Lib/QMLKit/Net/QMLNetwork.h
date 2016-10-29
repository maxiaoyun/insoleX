//
//  QMLNetwork.h
//  QMLRecord
//
//  Created by Myron on 15/8/1.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
typedef NSData* (^QMLNetDataHandle)(NSData *);
@interface QMLNetwork : QMLObj

+(void)setReqDataHandle:(QMLNetDataHandle)handle;
+(void)setRevDataHandle:(QMLNetDataHandle)handle;

+(NSData*)syncReq:(NSURLRequest*)req error:(NSError **)error;
+(NSData *)syncPostJsonData:(NSData *)data url:(NSURL *)url error:(NSError **)error;
+(NSData *)syncPostJsonDataWithDict:(NSDictionary *)dict url:(NSURL *)url error:(NSError **)error;

+(NSData *)syncGetWithUrl:(NSURL *)url error:(NSError **)error;
@end
