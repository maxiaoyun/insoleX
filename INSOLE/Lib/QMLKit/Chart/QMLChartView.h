//
//  QMLChartView.h
//  testQMLKit
//
//  Created by Myron on 15/10/27.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLView.h"
#import "QMLShapeView.h"
@class QMLShapeLayer;




typedef struct QMLCharViewInfoStruct {
    
    /**
     *	@brief	虚线显示 默认虚线
     */
    unsigned char dashLine:1;
    
    /**
     *	@brief	显示X坐标轴线 默认显示
     */
    unsigned char showXAxis:1;
    
    /**
     *	@brief	显示Y坐标轴线 默认显示
     */
    unsigned char showYAxis:1;
    
    /**
     *	@brief	显示Y轴刻度线  默认显示
     */
    unsigned char showLine:1;
    
    /**
     *	@brief	显示Y轴刻度 默认显示
     */
    unsigned char showLineTitle:1;
    
    /**
     *	@brief	显示X轴刻度  默认显示
     */
    unsigned char showXAxisTitle:1;
    
    /**
     *	@brief	显示X轴刻度线  默认显示
     */
    unsigned char showXAxisLine:1;
    
    /**
     *	@brief	显示Y轴最后的刻度线 默认显示
     */
    unsigned char showLastLine:1;
    
}QMLCharViewInfoStruct,*QMLCharViewInfoStructRef;


/**
 *	@brief	定义坐标轴
 */
@interface QMLChartView : QMLView

/**
 *	@brief	Y轴刻度线颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *lineColor;

/**
 *	@brief	Y轴刻度线宽度
 */
@property(nonatomic,assign)float lineWidth;

/**
 *	@brief	坐标轴线宽度
 */
@property(nonatomic,assign)float axisLineWidth;

/**
 *	@brief	坐标轴线颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *axisLineColor;

/**
 *	@brief	Y轴刻度数目
 */
@property(nonatomic,assign)int lineCnt;

/**
 *	@brief	Y轴刻度间隔
 */
@property(nonatomic,assign)float lineSpan;

/**
 *	@brief	X轴标题步长，即每隔多少个刻度显示标题
 */
@property(nonatomic,assign)int xAxisTitleStep;

/**
 *	@brief	X轴刻度数目
 */
@property(nonatomic,assign)int xAxisCnt;

/**
 *	@brief	X轴刻度间隔
 */
@property(nonatomic,assign)float xAxisSpan;
/**
 *	@brief	刻度值与坐标轴的间距
 */
@property(nonatomic,assign)float spanForTitle;

/**
 *	@brief	Y轴刻度值的最大宽度
 */
@property(nonatomic,assign)float widthForLineTitle;

/**
 *	@brief	底部留空
 */
@property(nonatomic,assign)float bottom;

/**
 *	@brief	头部留空
 */
@property(nonatomic,assign)float top;

/**
 *	@brief	表格项的Y轴偏转
 */
@property(nonatomic,assign)float contentYOffset;

/**
 *	@brief	表格项的X轴偏转  对于柱形图是无效的
 */
@property(nonatomic,assign)float contentXOffset;

/**
 *	@brief	坐标轴配置信息
 */
@property(nonatomic,readonly)QMLCharViewInfoStructRef info;

/**
 *	@brief	获取Y轴刻度值的信息
 */
@property(nonatomic,copy)void (^lineTitleInfo)(int index,NSString **titleRef,UIFont **fontRef);

/**
 *	@brief	获取X轴刻度值的信息 一般依赖item获取 
 *  只有使用addLine:color:lineWidth:dotRadius:animationTime 才会被调用
 */
@property(nonatomic,copy)void (^xAxisTitleInfo)(int index,NSString **titleRef,UIFont **fontRef);

/**
 *	@brief	虚线信息 lineLenRef 是实线的长度 whiteLenRef 是每个实线的间距
 */
@property(nonatomic,copy)void(^dashInfo)(CGFloat *lineLenRef,CGFloat *whiteLenRef);

/**
 *	@brief	触控事件
 */
@property(nonatomic,copy)void(^touchWithXAxis)(int index,NSArray *points,QMLTouchEventType type,QMLShapeView *inView);

-(NSString *)addLine:(NSArray *)values color:(UIColor *)color lineWidth:(float)width dotRadius:(float)dotRadius animationTime:(float)animationTime;
//QMLLineChartItem
-(NSString *)addLineWithItems:(NSArray *)items lineColor:(UIColor *)lineColor lineWidth:(float)width dotRadius:(float)dotRadius animationTime:(float)animationTime;
//QMLPieChartItem
-(NSString *)addBar:(NSArray *)items cornerRadius:(float)cornerRadius animationTime:(float)animationTime;
-(QMLShapeLayer *)shapeLayerWithFlag:(NSString *)flag;
-(void)emptyData;


-(void)scrollOffset:(CGPoint)offset;
-(UIScrollView *)getCntSc;
@end
