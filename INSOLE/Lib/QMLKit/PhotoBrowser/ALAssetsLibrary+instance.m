//
//  ALAssetsLibrary+instance.m
//  USENSE
//
//  Created by Myron on 16/2/15.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "ALAssetsLibrary+instance.h"

@implementation ALAssetsLibrary (instance)
+(ALAssetsLibrary *)sharedAssetsLibrary{
    static dispatch_once_t onceToken;
    static ALAssetsLibrary *S_QML_assetsLibrary = nil;
    dispatch_once(&onceToken, ^{
        S_QML_assetsLibrary = [[ALAssetsLibrary alloc]init];
    });
    return S_QML_assetsLibrary;
}
@end
