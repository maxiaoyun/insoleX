//
//  QMLNetAction.m
//  QMLRecord
//
//  Created by Myron on 15/8/1.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLNetAction.h"
#import "QMLNetwork.h"

@implementation QMLNetAction
+(void)postJsonData:(NSData *)data url:(NSURL *)url callBack:(QMLNetCallback)callback{
    dispatch_queue_t g_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t m_queue = dispatch_get_main_queue();
    dispatch_async(g_queue, ^{
        NSError *error = nil;
        NSData *revData = [QMLNetwork syncPostJsonData:data url:url error:&error];
        dispatch_async(m_queue, ^{
            if (callback) {
                if (revData) {
                    NSError *r_error = nil;
                    id object= [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingMutableContainers error:&r_error];
                    callback(object,r_error);
                }else{
                    callback(nil,[NSError errorWithDomain:@"返回数据为null" code:110 userInfo:nil]);
                }
            }
        });
    });
}
+(void)postJsonDataWithDict:(NSDictionary *)dict url:(NSURL *)url callBack:(QMLNetCallback)callback{
    dispatch_queue_t g_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t m_queue = dispatch_get_main_queue();
    dispatch_async(g_queue, ^{
        NSError *error = nil;
        NSData *revData = [QMLNetwork syncPostJsonDataWithDict:dict url:url error:&error];
        dispatch_async(m_queue, ^{
            if (callback) {
                if (revData) {
                    NSError *r_error = nil;
                    id object= [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingMutableContainers error:&r_error];
                    callback(object,r_error);
                }else{
                    callback(nil,[NSError errorWithDomain:@"返回数据为null" code:110 userInfo:nil]);
                }
            }
        });
    });
}
+(void)reqGetDataWithDict:(NSDictionary *)dict url:(NSString *)baseUrl callBack:(QMLNetCallback)callback{
    NSMutableString *str  = [NSMutableString stringWithFormat:@"%@?",baseUrl];
    for (NSString *key in dict.allKeys) {
        [str appendFormat:@"%@=%@&",key,[dict objectForKey:key]];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    
    dispatch_queue_t g_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t m_queue = dispatch_get_main_queue();
    dispatch_async(g_queue, ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:4]];
        
        NSData *revData = [QMLNetwork syncGetWithUrl:url error:&error];
        dispatch_async(m_queue, ^{
            if (callback) {
                if (revData) {
                    NSError *r_error = nil;
                    id object= [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingMutableContainers error:&r_error];
                    callback(object,r_error);
                }else{
                    callback(nil,[NSError errorWithDomain:@"返回数据为null" code:110 userInfo:nil]);
                }
            }
        });
    });
    
}
@end
