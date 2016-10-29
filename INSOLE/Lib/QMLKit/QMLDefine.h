//
//  QMLDefine.h
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//


#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#ifndef testQMLKit_QMLDefine_h
#define testQMLKit_QMLDefine_h


typedef void(^VVBlock)(void);
typedef void(^VIBlock)(int index);
typedef void(^VFBlock)(float);
typedef void(^VDBlock)(NSDictionary *dict);
typedef void(^VSBlock)(NSSet *);
typedef void(^VBBlock)(BOOL);

typedef struct QMLEdge {
    float left;
    float top;
    float right;
    float bottom;
} QMLEdge;

typedef enum : NSUInteger {
    QMLDirectionUp,
    QMLDirectionDown,
    QMLDirectionLeft,
    QMLDirectionRight
} QMLDirection;

typedef enum:NSUInteger{
    QMLPositionCenter = 0,
    QMLPositionTop,
    QMLPositionBottom,
    QMLPositionLeft  = QMLPositionTop,
    QMLPositionRight = QMLPositionBottom,
}QMLPosition;

typedef enum : NSUInteger {
    QMLSeparatorTypeLine,
    QMLSeparatorTypeDash,
    QMLSeparatorTypeNone,
} QMLSeparatorType;



typedef enum : unsigned char {
    QMLLogLevelNone     = 0,     //全部不log
    QMLLogLevelDealloc  = 1<<0,  //dealloc log   用于监控内存释放
    QMLLogLevelDebug    = 1<<1,  //debug log     此log用于debug，譬如网络返回数据
    QMLLogLevelInfo     = 1<<2,  //info log
    QMLLogLevelError    = 1<<3,  // error log
    QMLLogLevelInternal = 1<<4,  // 内部log  默认打开
    QMLLogLevel6 = 1<<5,
    QMLLogLevel7 = 1<<6,
    QMLLogLevel8 = 1<<7, 
} QMLLogLevel;


#define KEY_WINDOW [UIApplication sharedApplication].keyWindow


//颜色
#define SAFE_COLOR(x)   ((x)>0.0f?((x)>255.0f?255.0f:(x)):0.0f)

#define COLOR_WITH_RGB(r,g,b) [UIColor colorWithRed:SAFE_COLOR(r)/255.0 \
green:SAFE_COLOR(g)/255.0 \
blue:SAFE_COLOR(b)/255.0 \
alpha:1]

#define COLOR_WITH_RGBA(r,g,b,a) [UIColor colorWithRed:SAFE_COLOR(r)/255.0 \
green:SAFE_COLOR(g)/255.0 \
blue:SAFE_COLOR(b)/255.0 \
alpha:SAFE_COLOR(a)/255.0]

#define RAND_COLOR COLOR_WITH_RGB(arc4random()%255, arc4random()%255, arc4random()%255)



#define DEALLOC_PRINT do{if ([QMLLog getConsoleLog]&&[QMLLog supportsLogWithLogLevel:QMLLogLevelDealloc]) {[QMLLog getConsoleLog](@"%s",__FUNCTION__);}}while (0)


#define QMLog(format,...)     do{if ([QMLLog getConsoleLog]&&[QMLLog supportsLogWithLogLevel:QMLLogLevelInternal]){[QMLLog getConsoleLog]((@"%s" "[%d] " format), __FUNCTION__, __LINE__, ##__VA_ARGS__);}}while(0)


#define QMLLOG_INFO(log)  [QMLLog infoLog:log]
#define QMLLOG_DEBUG(log) [QMLLog debugLog:log]
#define QMLLOG_ERROR(log) [QMLLog errorLog:log]


#define LOG_I(format,...) do{if ([QMLLog getConsoleLog]&&[QMLLog supportsLogWithLogLevel:QMLLogLevelInfo]) {[QMLLog getConsoleLog]((format), ##__VA_ARGS__);}}while(0)
#define LOG_D(format,...) do{if ([QMLLog getConsoleLog]&&[QMLLog supportsLogWithLogLevel:QMLLogLevelDebug]){[QMLLog getConsoleLog]((format), ##__VA_ARGS__);}}while(0)
#define LOG_E(format,...) do{if ([QMLLog getConsoleLog]&&[QMLLog supportsLogWithLogLevel:QMLLogLevelError]){[QMLLog getConsoleLog]((format), ##__VA_ARGS__);}}while(0)


#if __has_feature(objc_arc)
#define QML_DEFINE_PRO_RETAIN strong
#define SET_PAR(_p,p) do{_p=p;}while(0)
#define SET_BLOCK(_b,b) do {\
if (_b != b) {\
    if (_b) {\
        Block_release((__bridge void*)_b);\
    }\
    _b = (__bridge typeof(_b))Block_copy((__bridge void*)b);\
}\
} while (0)
#else
#define QML_DEFINE_PRO_RETAIN retain
#define SET_PAR(_p,p) do{[p retain];[_p release];_p=p;}while(0)
#define SET_BLOCK(_b,b) do {\
if (_b != b) {\
    if (_b) {\
        Block_release(_b);\
    }\
    _b = Block_copy(b);\
}\
} while (0)
#endif

#endif
