//
//  UIImageView+imageLoader.h
//  testQMLKit
//
//  Created by Myron on 15/7/28.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMLDefine.h"


typedef enum : NSUInteger{
    QMLImgLoadStateLoading = 1,
    QMLImgLoadStateSuccess = 2,
    QMLImgLoadStateFailure = 3,
}QMLImgLoadState;

@interface UIImageView (imageLoader)
@property(nonatomic,assign)BOOL isLoading;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSURL *imageUrl;
/**
 *  net url to local save path
 */
@property(nonatomic,copy)NSString *(^NUTLP)(NSURL*);
/**
 *  从url加载图片   并行队列
 *
 *  @param url    图片路径
 *  @param finish 完成后的回调
 */
-(void)loadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *img,NSData*imgData))finish;

/**
 *	@brief	从url加载图片   串行队列
 *
 *	@param 	url 	 图片路径
 *	@param 	finish 	 完成后的回调
 *
 */
-(void)serialLoadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *img,NSData*imgData))finish;

/**
 *	@brief	从url加载图片   并行队列
 *
 *	@param 	url 	图片路径
 *
 *	@return	
 */
-(void)concurrentLoadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *img,NSData*imgData))finish;
-(void)loadImageWithUrlStateChangeToState:(QMLImgLoadState)state forUrl:(NSURL*)url;

+(void)setNUTLPFun:(NSString *(*)(NSURL *))fun;
+(NSString *(*)(NSURL *))getNUTLPFun;
+(NSString *)getSavePathWithUrlStr:(NSString *)urlStr;
@end

/**
 *  QMLImgLoadState 发生变化是抛出通知
 */
static NSString *NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED = @"NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED";
