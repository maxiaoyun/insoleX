//
//  QMLPhotoCollectionCell.m
//  testQMLKit
//
//  Created by Myron on 15/11/9.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLPhotoCollectionCell.h"
#import "QMLDefine.h"
@interface QMLPhotoCollectionCell ()
{
    UIImageView *imageView;
    UIImageView *tintImageView;
}
@end
@implementation QMLPhotoCollectionCell
-(void)setImage:(UIImage *)image{
    SET_PAR(_image,image);
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
    }
    imageView.image = image;
}
-(void)setTintImage:(UIImage *)tintImage{
    SET_PAR(_tintImage,tintImage);
    if (!tintImageView) {
        if (tintImage) {
            float scale = [[UIScreen mainScreen] scale];
            float w = CGImageGetWidth(tintImage.CGImage)/scale;
            float h = CGImageGetHeight(tintImage.CGImage)/scale;
            tintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            tintImageView.center = CGPointMake(self.frame.size.width-w/2-5, h/2+5);
            [self addSubview:tintImageView];
        }
    }
    tintImageView.image = _tintImage;
}
-(void)makeTintImgCenter{
    tintImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
@end
