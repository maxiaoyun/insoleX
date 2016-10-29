//
//  QMLObj.h
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMLDefine.h"
#import "NSObject+flag.h"   

@interface QMLObj : NSObject
@property(nonatomic,readonly)NSDictionary *proDict;
-(void)setupDefineValues;
-(NSString *)description;
@end
