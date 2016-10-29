//
//  QMLSegmentControl.h
//  QMLib
//
//  Created by 流云_陌陌 on 14-8-12.
//  Copyright (c) 2014年 流云_陌陌. All rights reserved.
//

#import "QMLView.h"
/**
 *	@brief	QMLSegItem卡  支持图片、文字、图片加文字
 */
@interface QMLSegmentControl : QMLView

/**
 *	@brief	QMLSegItem 指定显示的单元，此时开始绘制界面
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *items;

@property(nonatomic,assign)int selectIndex;
/**
 *	@brief	每个单元之间 分割线的宽度
 */
@property(nonatomic,assign)float separatorWidth;

/**
 *	@brief	每个单元之间 分割线的颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *separatorColor;

/**
 *	@brief	字体 默认10号字体
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *font;
/**
 *	@brief	选项卡每个单元之间的间距 默认为0
 */
@property(nonatomic,assign)float separatorSpan;

/**
 *	@brief	选项卡选中的项发生变化的回调
 */
@property(nonatomic,copy)VIBlock valueChanged;

/**
 *	@brief	图片的y轴偏转
 */
@property(nonatomic,assign)float imgYOffset;
@property(nonatomic,assign)float imgScale;

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items;
-(void)redrawView;
/**
 *	@brief	选中某个单元
 *
 *	@param 	rep 	是否响应回调，当rep为YES会响应valueChanged回调
 *	@param 	selectIndex 	选中单元的索引
 *
 *	@return
 */
-(void)showIndexWithRes:(BOOL)rep index:(int)selectIndex;
-(void)updateTitle:(NSString *)title withIndex:(int)index;
@end
