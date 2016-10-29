//
//  QMLPhotoGroupListVC.h
//  USENSE
//
//  Created by Myron on 16/1/5.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface QMLPhotoGroupListVC : QMLViewController
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, copy) void (^didSelectedGroup)(ALAssetsGroup *group);

@end


