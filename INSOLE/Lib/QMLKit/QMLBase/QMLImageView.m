//
//  QMLImageView.m
//  testQMLKit
//
//  Created by Myron on 14/12/30.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLImageView.h"
#import "QMLDefine.h"
#import "QMLLayoutFunction.h"
#import "QMLLog.h"
#import "UIImageView+imageLoader.h"
#import "UIImage+handle.h"
@interface QMLImageView()
{
    UIImageView *placeHolderImgView;
}
@end
@implementation QMLImageView
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
-(void)setupDefineValues
{
    _scale=1;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self addObservers];
    }else{
        [self removeObservers];
    }
}
-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImageWithUrlStateChanged:) name:NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED object:nil];
}
-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED object:nil];
}
-(void)loadImageWithUrlStateChanged:(NSNotification *)notification{
    QMLImgLoadState state = [notification.object intValue];
    if (state==QMLImgLoadStateSuccess) {
        NSURL *url = [notification.userInfo objectForKey:@"url"];
        if (url&&[[self.imageUrl description] isEqualToString:[url description]]) {
            UIImage *image = [notification.userInfo objectForKey:@"image"];
            self.image = [image fitToSize:self.frame.size];
        }
    }
}
-(id)init
{
    if (self=[super init]) {
        [self setupDefineValues];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setupDefineValues];
    }
    return self;
}
-(id)initWithImage:(UIImage *)image
{
    if (self=[super initWithImage:image]) {
        [self setupDefineValues];
        [self adjustFrame];
    }
    return self;
}
-(void)setPlaceHolder:(UIImage *)placeHolder{
    SET_PAR(_placeHolder, placeHolder);
    
    if ([placeHolder isKindOfClass:[UIImage class]]) {
        if (!placeHolderImgView) {
            float scale = [[UIScreen mainScreen] scale];
            float w = CGImageGetWidth(placeHolder.CGImage)/scale;
            float h = CGImageGetHeight(placeHolder.CGImage)/scale;
            placeHolderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            placeHolderImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            placeHolderImgView.image = placeHolder;
            [self addSubview:placeHolderImgView];
        }
    }else{
        [placeHolderImgView  removeFromSuperview];
        placeHolderImgView = nil;
    }
}
-(void)willRemoveSubview:(UIView *)subview{
    if (subview==placeHolderImgView) {
        placeHolderImgView = nil;
    }
}
-(void)setImage:(UIImage *)image{
    
    [super setImage:image];
    if ([image isKindOfClass:[UIImage class]]) {
        [placeHolderImgView removeFromSuperview];
        placeHolderImgView = nil;
    }
}
-(void)setScale:(float)scale{
    _scale=scale>0?scale:0;
    _scale=_scale>1?1:_scale;
    [self adjustFrame];
}
-(void)adjustFrame
{
    if (self.image) {
        CGRect rect = self.frame;
        rect.size.width=self.image.size.width*self.scale;
        rect.size.height = self.image.size.height*self.scale;
        self.frame=rect;
    }
}
@end
