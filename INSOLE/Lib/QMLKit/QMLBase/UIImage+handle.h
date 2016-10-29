//
//  UIImage+handle.h
//  testQMLKit
//
//  Created by Myron on 15/7/28.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (handle)
/**
 *  图片适应某个尺寸，多出的部分会被裁剪掉
 *
 *  @param size 适应的尺寸
 *
 *  @return 操作之后的图片
 */
-(UIImage *)fitToSize:(CGSize)size;
-(UIImage *)fixOrientation;
@end
