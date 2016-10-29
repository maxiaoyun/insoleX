//
//  UIImage+handle.m
//  testQMLKit
//
//  Created by Myron on 15/7/28.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "UIImage+handle.h"

@implementation UIImage (handle)
-(UIImage *)fitToSize:(CGSize)size
{
    float w = CGImageGetWidth(self.CGImage);
    float h = CGImageGetHeight(self.CGImage);
    
    if (size.width/w>size.height/h) {
        return [self baseWidthFitToSize:size];
    }else{
        return [self baseHeightFitToSize:size];
    }
}
-(UIImage *)baseHeightFitToSize:(CGSize)size{
    float w = CGImageGetWidth(self.CGImage);
    float h = CGImageGetHeight(self.CGImage);
    
    float t_w = size.width;
    float t_h = size.height;
    float scale = h/t_h;
    float f_w = t_w * scale;
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((w-f_w)/2, 0, f_w, h));
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return img;
}
-(UIImage *)baseWidthFitToSize:(CGSize)size{
    float w = CGImageGetWidth(self.CGImage);
    float h = CGImageGetHeight(self.CGImage);
    
    float t_w = size.width;
    float t_h = size.height;
    
    float scale = w/t_w;
    float f_h = t_h * scale;
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(0, (h-f_h)/2, w, f_h));
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return img;
}

-(UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
