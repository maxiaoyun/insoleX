//
//  QMLNetAction.h
//  QMLRecord
//
//  Created by Myron on 15/8/1.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
typedef void (^QMLNetCallback)(id rev,NSError *error);
@interface QMLNetAction : QMLObj
+(void)postJsonData:(NSData *)data url:(NSURL *)url callBack:(QMLNetCallback)callback;
+(void)postJsonDataWithDict:(NSDictionary *)dict url:(NSURL *)url callBack:(QMLNetCallback)callback;
+(void)reqGetDataWithDict:(NSDictionary *)dict url:(NSString *)baseUrl callBack:(QMLNetCallback)callback;
@end
