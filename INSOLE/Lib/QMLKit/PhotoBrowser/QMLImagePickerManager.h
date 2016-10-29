//
//  QMLImagePickerManager.h
//  testQMLKit
//
//  Created by Myron on 16/3/31.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QMLImagePickerManager : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, copy)void(^didSelectedImage)(UIImage *image);
@property (nonatomic, copy)void(^willShowImagePicker)(void);
@property (nonatomic, copy)void(^didShowImagePicker)(void);
@property (nonatomic, assign) BOOL canEdit;
-(void)presentCamera;
-(void)presentSavedPhotosAlbum;
-(void)showActionSheet;
@end
