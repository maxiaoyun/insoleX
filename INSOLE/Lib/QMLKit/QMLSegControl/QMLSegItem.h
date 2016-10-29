//
//  QMLSegItem.h
//  QMLib
//
//  Created by 流云_陌陌 on 14-8-12.
//  Copyright (c) 2014年 流云_陌陌. All rights reserved.
//

#import "QMLObj.h"
#import "QMLLog.h"


@interface QMLSegItem : QMLObj
@property(nonatomic,copy)NSString  *title;

/**
 *	@brief	默认状态下 字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *defaultTextColor;

/**
 *	@brief	选中状态下 字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *heightLightTextColor;

/**
 *	@brief	默认状态下 显示的图片
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIImage *defaultImage;

/**
 *	@brief	选中状态下  显示的图片
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIImage *heightLightImage;

/**
 *	@brief  默认状态下 背景颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *defaultbgColor;

/**
 *	@brief	选中状态下  背景颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *heightLightbgColor;

@property(nonatomic,assign)float xOffset;
@property(nonatomic,assign)float yOffset;
@property(nonatomic,assign)float itemWidth;
@end
