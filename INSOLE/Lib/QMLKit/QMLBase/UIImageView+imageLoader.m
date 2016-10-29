//
//  UIImageView+imageLoader.m
//  testQMLKit
//
//  Created by Myron on 15/7/28.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "UIImageView+imageLoader.h"
#import <objc/runtime.h>
#import "QMLUnit.h"
#import "QMLLog.h"

static char *s_isLoading_UIImageView_imageLoader_pro_key = "s_isLoading_UIImageView_imageLoader_pro_key";
static char *s_nutlp_UIImageView_imageLoader_pro_key     = "s_nutlp_UIImageView_imageLoader_pro_key";
static char *s_imageUrl_UIImageView_imageLoader_pro_key  = "s_imageUrl_UIImageView_imageLoader_pro_key";
static NSMutableDictionary *loadingDict = nil;

static NSString *(*s_url_to_save_path_fun)(NSURL*) = NULL;
static dispatch_queue_t s_imageLoaderQueue = nil;

@implementation UIImageView (imageLoader)
@dynamic isLoading;
@dynamic NUTLP;
+(void)setNUTLPFun:(NSString *(*)(NSURL *))fun{
    s_url_to_save_path_fun = fun;
}
+(NSString *(*)(NSURL *))getNUTLPFun{
    return s_url_to_save_path_fun;
}
+(NSString *)getSavePathWithUrlStr:(NSString *)urlStr{
    return s_url_to_save_path_fun([NSURL URLWithString:urlStr]);
}
+(dispatch_queue_t)getImageLoaderQueue{
    if (!s_imageLoaderQueue) {
        s_imageLoaderQueue = dispatch_queue_create("com.myron.imageLoader", DISPATCH_QUEUE_SERIAL);//串行队列
    }
    return s_imageLoaderQueue;
}
-(void)setNUTLP:(NSString *(^)(NSURL *))NUTLP{
    [self willChangeValueForKey:@"NUTLP"];
    objc_setAssociatedObject(self, s_nutlp_UIImageView_imageLoader_pro_key, NUTLP, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"NUTLP"];
}
-(NSString *(^)(NSURL *))NUTLP{
    id obj = objc_getAssociatedObject(self, s_nutlp_UIImageView_imageLoader_pro_key);
    return obj;
}
-(void)setIsLoading:(BOOL)isLoading{
    [self willChangeValueForKey:@"isLoading"];
    objc_setAssociatedObject(self, s_isLoading_UIImageView_imageLoader_pro_key, @(isLoading), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"isLoading"];
}
-(BOOL)isLoading{
    id obj = objc_getAssociatedObject(self, s_isLoading_UIImageView_imageLoader_pro_key);
    if (!obj) {
        return NO;
    }
    return [obj boolValue];
}
-(void)setImageUrl:(NSURL *)imageUrl{
    [self willChangeValueForKey:@"imageUrl"];
    objc_setAssociatedObject(self, s_imageUrl_UIImageView_imageLoader_pro_key, imageUrl, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"imageUrl"];
}
-(NSURL *)imageUrl{
    return objc_getAssociatedObject(self, s_imageUrl_UIImageView_imageLoader_pro_key);
}
-(void)setState:(QMLImgLoadState)state forUrl:(NSURL*)url {
    [loadingDict setObject:@(state) forKey:url];
    if (state==QMLImgLoadStateSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED object:@(state) userInfo:@{@"url":url,@"image":self.image}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOT_NAME_IMAGE_LOAD_FOR_URL_STATE_CHANGED object:@(state) userInfo:@{@"url":url}];
    }
    [self loadImageWithUrlStateChangeToState:state forUrl:url];
}
-(QMLImgLoadState)getStateForUrl:(NSURL*)url{
    QMLImgLoadState state = [[loadingDict objectForKey:url] intValue];
    return state;
}
-(void)loadImageWithUrlStateChangeToState:(QMLImgLoadState)state forUrl:(NSURL*)url {
    
}
-(void)loadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *,NSData*))finish
{
    [self loadImageWithUrl:url serial:NO finish:finish];
}
-(void)serialLoadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *,NSData*))finish{
    [self loadImageWithUrl:url serial:YES finish:finish];
}
-(void)concurrentLoadImageWithUrl:(NSURL *)url finish:(void(^)(UIImage *,NSData*))finish{
    [self loadImageWithUrl:url serial:NO finish:finish];
}

-(void)loadImageWithUrl:(NSURL *)url serial:(BOOL)serial finish:(void(^)(UIImage *,NSData*))finish{
    if (!url) {
        return;
    }
    
    dispatch_queue_t loader_queue=serial?[UIImageView getImageLoaderQueue]:dispatch_get_global_queue(0, 0);
    dispatch_queue_t m_queue=dispatch_get_main_queue();
    
    NSString *key = [NSString stringWithFormat:@"%@",url];
    
    __weak typeof(self)bSelf = self;
    
    dispatch_async(loader_queue, ^{
        UIImage *savedImage = [QMLUnit cachedObjForKey:key];
        dispatch_async(m_queue, ^{
            if (savedImage) {
                self.image = savedImage;
                [self setState:QMLImgLoadStateSuccess forUrl:url];
                if (finish) {
                    finish(savedImage,nil);
                }
                QMLog(@"从缓存中加载图片");
            }else{
                [bSelf loadImageFormSavePath:url serial:serial finish:finish];
            }
        });
    });
}
-(void)loadImageFormSavePath:(NSURL *)url serial:(BOOL)serial finish:(void(^)(UIImage *,NSData*))finish{

    self.imageUrl = url;
    NSString *savePath = nil;
    if ([UIImageView getNUTLPFun]) {
        savePath = [UIImageView getNUTLPFun](url);
    }else if(self.NUTLP){
        savePath = self.NUTLP(url);
    }
    if (savePath) {
        dispatch_queue_t loader_queue=serial?[UIImageView getImageLoaderQueue]:dispatch_get_global_queue(0, 0);
        dispatch_queue_t m_queue=dispatch_get_main_queue();
        NSString *key = [NSString stringWithFormat:@"%@",url];
        __weak typeof(self)bSelf = self;
        dispatch_async(loader_queue, ^{
            UIImage *image = [UIImage imageWithContentsOfFile:savePath];
            NSData *data = nil;
            if (image) {
                [QMLUnit cacheObj:image forKey:key];
            }
            dispatch_async(m_queue, ^{
                if (image) {
                    self.image = image;
                    [self setState:QMLImgLoadStateSuccess forUrl:url];
                    if (finish) {
                        finish(image,data);
                    }
                    QMLog(@"从文件系统中加载图片");
                }else{
                    [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
                    [bSelf loadImageFormNetWithUrl:url serial:serial savePath:savePath finish:finish];
                }
            });
        });
    }else{
        [self loadImageFormNetWithUrl:url serial:serial savePath:savePath finish:finish];
    }
}
-(void)loadImageFormNetWithUrl:(NSURL *)url serial:(BOOL)serial savePath:(NSString *)savePath finish:(void(^)(UIImage *,NSData*))finish{
    if (self.isLoading) {
        return;
    }
    if (!loadingDict) {
        loadingDict = [NSMutableDictionary dictionary];
    }
    QMLImgLoadState state = [self getStateForUrl:url];
    if (state==QMLImgLoadStateLoading) {
        return;
    }
    
    
    [self setState:QMLImgLoadStateLoading forUrl:url];
    
    self.isLoading = YES;
    
    dispatch_queue_t loader_queue=serial?[UIImageView getImageLoaderQueue]:dispatch_get_global_queue(0, 0);
    dispatch_queue_t m_queue=dispatch_get_main_queue();
    NSString *key = [NSString stringWithFormat:@"%@",url];
    
    __weak typeof(self)bSelf=self;
    dispatch_async(loader_queue, ^{
        QMLog(@"开始下载图片：%@",url);
        NSData *data=[NSData dataWithContentsOfURL:url];
        UIImage *img=[UIImage imageWithData:data];
        dispatch_async(m_queue, ^{
            QMLog(@"结束下载图片：%@",url);
            bSelf.isLoading = NO;
            if (img) {
                bSelf.image=img;
                [QMLUnit cacheObj:img forKey:key];
                if (savePath) {
                    [data writeToFile:savePath atomically:NO];
                }
                [bSelf setState:QMLImgLoadStateSuccess forUrl:url];
                if (finish) {
                    finish(img,data);
                }
            }else{
                [bSelf setState:QMLImgLoadStateFailure forUrl:url];
                if (finish) {
                    finish(nil,nil);
                }
            }
        });
    });
}
@end
