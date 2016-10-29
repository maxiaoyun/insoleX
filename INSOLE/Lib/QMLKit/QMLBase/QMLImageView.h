//
//  QMLImageView.h
//  testQMLKit
//
//  Created by Myron on 14/12/30.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLObj.h"
/**
 *	@brief	图片视图 默认会监听 NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED 通知 收到通知触发修改image为传入的image
 *  当 UIImageView 的 QMLImgLoadState 状态被修改时则会抛出 NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED 通知
 */
@interface QMLImageView : UIImageView

@property(nonatomic,assign)float scale;//0--1 default .5;
@property(nonatomic,strong)UIImage *placeHolder;
-(void)setupDefineValues;
-(void)addObservers;
-(void)removeObservers;
@end
