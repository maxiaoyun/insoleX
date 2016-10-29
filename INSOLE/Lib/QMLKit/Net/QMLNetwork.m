//
//  QMLNetwork.m
//  QMLRecord
//
//  Created by Myron on 15/8/1.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLNetwork.h"
#import "QMLLog.h"

static QMLNetDataHandle s_reqDataHandle = nil;
static QMLNetDataHandle s_revDataHandle = nil;

@implementation QMLNetwork

+(void)setReqDataHandle:(QMLNetDataHandle)handle{
    s_reqDataHandle = handle;
}
+(void)setRevDataHandle:(QMLNetDataHandle)handle{
    s_revDataHandle = handle;
}


+(NSData*)syncReq:(NSURLRequest*)req error:(NSError **)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *data = [NSURLConnection sendSynchronousRequest:req
                                              returningResponse:nil error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (!data) {
        LOG_E(@"为null：%@",req.URL);
    }
    if (s_revDataHandle) {
        return s_revDataHandle(data);
    }
    return data;
}
+(NSData *)syncPostJsonData:(NSData *)data url:(NSURL *)url error:(NSError **)error{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    return [self syncReq:request error:error];
}
+(NSData *)syncPostJsonDataWithDict:(NSDictionary *)dict url:(NSURL *)url error:(NSError **)error{
    if (!dict){
        return [self syncPostJsonData:nil url:url error:error];
    }
    if (![NSJSONSerialization isValidJSONObject:dict]) {
        if(error)*error=[NSError errorWithDomain:@"传入参数不能转换为json数据！" code:1 userInfo:nil];
        return nil;
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:error];
    if (!jsonData) {
        return nil;
    }
    if (s_reqDataHandle) {
        jsonData = s_reqDataHandle(jsonData);
    }
    return [self syncPostJsonData:jsonData url:url error:error];
}
+(NSData *)syncGetWithUrl:(NSURL *)url error:(NSError **)error{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    return [self syncReq:request error:error];
}
@end
