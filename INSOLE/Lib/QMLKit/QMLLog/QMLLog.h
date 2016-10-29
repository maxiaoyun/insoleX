//
//  QMLLog.h
//  testQMLKit
//
//  Created by Myron on 15/7/18.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import "QMLDefine.h"


@interface QMLLog : QMLObj
@property(nonatomic,copy)NSString *localPath;
/**
 *	@brief	设置log的层级
 *
 *	@param 	logLevel 	需要log出来的类型
 *
 *	@return
 */
+(uint8_t)setGlobalLogLevel:(uint8_t)logLevel;

/**
 *	@brief	设置log函数
 *
 *	@return
 */
+(void)setConsoleLog:(void(*)(NSString *format, ...))log;
+(void(*)(NSString *format, ...))getConsoleLog;

/**
 *	@brief	重定向log
 *
 *	@param 	logPath 	log的本地全路径
 *
 *	@return
 */
+(void)redirectLogToPath:(NSString *)logPath;

/**
 *	@brief	判断是否支持指定层级的log
 *
 *	@param 	logLevel 	log 层级
 *
 *	@return	支持返回YES，否则返回NO
 */
+(BOOL)supportsLogWithLogLevel:(QMLLogLevel)logLevel;



+(void)infoLog:(NSString*)log;
+(void)debugLog:(NSString*)log;
+(void)errorLog:(NSString*)log;
+(void)deallocLog:(NSString*)log;



-(void)addDeallocLog:(NSString *)log;
-(void)addInfoLog:(NSString *)log;
-(void)addDebugLog:(NSString *)log;
-(void)addErrorLog:(NSString *)log;
-(void)addLog:(NSString *)log color:(UIColor *)color font:(UIFont *)font logLevel:(QMLLogLevel)logLevel;
-(NSAttributedString *)getLog;


@end

