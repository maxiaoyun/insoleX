//
//  QMLPhotoBrowserVC.h
//  testQMLKit
//
//  Created by Myron on 15/11/9.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum : unsigned char {
    UBCPhotoBrowserSourceTypePhoto = 0x01,
    UBCPhotoBrowserSourceTypeVideo = 0x01<<1,
    UBCPhotoBrowserSourceTypeAll   = 0xFF,
}UBCPhotoBrowserSourceType;

@interface QMLPhotoBrowserVC : QMLViewController
@property (nonatomic, copy)CGRect(^getCntFrame)(void);
@property (nonatomic, copy) void (^didCreateView)(void);
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UIView *barView;
@property (nonatomic, readonly) UIView *statusView;
@property (nonatomic, readonly) UILabel *titleLa;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) int limit;
@property (nonatomic, strong) UIFont *doneFont;
@property (nonatomic, strong) UIColor *doneColor;
@property (nonatomic, copy) NSString *doneTitle;
@property (nonatomic, assign) int rowCntInSection;
@property (nonatomic, copy)void(^setTintImg)(UIImage **defaultTintImg,UIImage **selectedTintImg);
@property (nonatomic, copy) void (^doneBtnClick)(NSArray *results);
@property (nonatomic, copy) void (^outLimit)(void);
@property (nonatomic, copy) BOOL (^imageSelected)(NSURL *url);
@property (nonatomic, strong) NSArray *results;
@property (nonatomic,assign)UBCPhotoBrowserSourceType sourceType;
@property (nonatomic,copy)BOOL (^shouldSelect)(ALAsset *asset);
@property (nonatomic,copy)void(^noReadAuthorizationHandle)(void);


@property (nonatomic, strong) ALAssetsGroup *group;
-(void)insert:(ALAsset *)asset selected:(BOOL)selected;
-(void)reloadData;
-(void)makeDoneBtnFront;
-(void)presentGroupListWithInfoDict:(NSDictionary *)infoDict;
@end

const extern NSString *QML_PHOTO_GROUP_LIST_VC_INFO_TITLE;
const extern NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_DEFAULT;
const extern NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_HIGH_LIGHTED;
const extern NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BAR_COLOR;
