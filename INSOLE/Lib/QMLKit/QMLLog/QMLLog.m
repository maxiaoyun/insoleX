//
//  QMLLog.m
//  testQMLKit
//
//  Created by Myron on 15/7/18.
//  Copyright (c) 2015年 Myron. All rights reserved.
//




#import "QMLLog.h"
#define LOG_INFO_COLOR_FOR_DEALLOC  [UIColor blackColor]
#define LOG_INFO_COLOR_FOR_INFO     [UIColor greenColor]
#define LOG_INFO_COLOR_FOR_DEBUG    [UIColor blueColor]
#define LOG_INFO_COLOR_FOR_ERROR    [UIColor redColor]

#define LOG_INFO_FONT_FOR_DEALLOC   [UIFont systemFontOfSize:10]
#define LOG_INFO_FONT_FOR_INFO      [UIFont systemFontOfSize:12]
#define LOG_INFO_FONT_FOR_DEBUG     [UIFont systemFontOfSize:15]
#define LOG_INFO_FONT_FOR_ERROR     [UIFont systemFontOfSize:18]

static uint8_t c_log_level = QMLLogLevelDealloc|QMLLogLevelInternal;
static void(*s_consoleLog)(NSString *format, ...) = NULL;
@implementation QMLLog
+(uint8_t)setGlobalLogLevel:(uint8_t)logLevel
{
    c_log_level = logLevel;
    return c_log_level;
}
+(void)setConsoleLog:(void(*)(NSString *format, ...))log{
    s_consoleLog = log;
}
+(void(*)(NSString *format, ...))getConsoleLog{
    return s_consoleLog;
}
+(void)redirectLogToPath:(NSString *)logPath{
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

+(BOOL)supportsLogWithLogLevel:(QMLLogLevel)logLevel{
    return (logLevel&c_log_level)==logLevel;
}
+(void)infoLog:(NSString*)log{
    if(s_consoleLog&&[self supportsLogWithLogLevel:QMLLogLevelInfo]){
        s_consoleLog(log);
    }
}
+(void)debugLog:(NSString*)log{
    if(s_consoleLog&&[self supportsLogWithLogLevel:QMLLogLevelDebug]){
        s_consoleLog(log);
    }
}
+(void)errorLog:(NSString*)log{
    if(s_consoleLog&&[self supportsLogWithLogLevel:QMLLogLevelError]){
        s_consoleLog(log);
    }
}
+(void)deallocLog:(NSString*)log{
    if(s_consoleLog&&[self supportsLogWithLogLevel:QMLLogLevelDealloc]){
        s_consoleLog(log);
    }
}




-(void)setupDefineValues{
    [super setupDefineValues];
}
-(NSString *)getTag:(QMLLogLevel)logLevel{
    switch (logLevel) {
        case QMLLogLevelDealloc:   return @"Dealloc log:";
        case QMLLogLevelDebug:     return @"Debug log:";
        case QMLLogLevelInfo:      return @"Info log:";
        case QMLLogLevelError:     return @"Error log:";
        default:
            break;
    }
    return @"QMLLog:";
}
-(void)addLog:(NSString *)log color:(UIColor *)color font:(UIFont *)font logLevel:(QMLLogLevel)logLevel{
    if ([QMLLog supportsLogWithLogLevel:logLevel]) {
        if (s_consoleLog) {
            s_consoleLog(log);
        }
        BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:self.localPath];
        if (!fileExist) {
            fileExist = [[NSFileManager defaultManager] createFileAtPath:self.localPath contents:nil attributes:nil];
        }
        if (fileExist) {
            NSString *logStr = [NSString stringWithFormat:@"\n%@%@",[self getTag:logLevel],log];
            NSAttributedString *aStr = [NSKeyedUnarchiver unarchiveObjectWithFile:self.localPath];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:aStr];
            [str appendAttributedString:[[NSAttributedString alloc] initWithString:logStr]];
            [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(str.length - logStr.length, logStr.length)];
            [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(str.length - logStr.length, logStr.length)];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:str];
            [data writeToFile:self.localPath atomically:NO];
        }
    }
}
-(NSAttributedString *)getLog{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.localPath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:self.localPath];
    }
    return nil;
}
-(void)addDeallocLog:(NSString *)log{
    [self addLog:log color:LOG_INFO_COLOR_FOR_DEALLOC font:LOG_INFO_FONT_FOR_DEALLOC logLevel:QMLLogLevelDealloc];
}
-(void)addInfoLog:(NSString *)log{
    [self addLog:log color:LOG_INFO_COLOR_FOR_INFO font:LOG_INFO_FONT_FOR_INFO logLevel:QMLLogLevelInfo];
}
-(void)addDebugLog:(NSString *)log{
    [self addLog:log color:LOG_INFO_COLOR_FOR_DEBUG font:LOG_INFO_FONT_FOR_DEBUG logLevel:QMLLogLevelDebug];
}
-(void)addErrorLog:(NSString *)log{
    [self addLog:log color:LOG_INFO_COLOR_FOR_ERROR font:LOG_INFO_FONT_FOR_ERROR logLevel:QMLLogLevelError];
}
@end

