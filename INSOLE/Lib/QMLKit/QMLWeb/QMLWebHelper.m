//
//  QMLWebHelper.m
//  testQMLKit
//
//  Created by Myron on 15/4/24.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLWebHelper.h"
#import "QMLLog.h"
static NSOperationQueue *web_queue_s = nil;

@implementation QMLWebHelper
+(NSOperationQueue *)sharedOperationQueue{
    if (!web_queue_s) {
        web_queue_s = [[NSOperationQueue alloc] init];
    }
    return web_queue_s;
}
+(void)saveLastModifyDate:(NSString *)lastModifyDate forRequest:(NSURLRequest*)request{
    [[NSUserDefaults standardUserDefaults] setObject:lastModifyDate forKey:[request.URL description]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)lastModifyDateForRequest:(NSURLRequest*)request{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[request.URL description]];
}
+(void)shouldLoadRequest:(NSURLRequest *)request callback:(VBBlock)callback{
    if (!callback) {
        return;
    }
    NSString *lastModify = [self lastModifyDateForRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[self sharedOperationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [(NSHTTPURLResponse *)response allHeaderFields];
        NSString *dateStr = [dict objectForKey:@"Last-Modified"];
        [self saveLastModifyDate:dateStr forRequest:request];

        callback(!lastModify||![lastModify isEqualToString:dateStr]);
    }];
}
@end
