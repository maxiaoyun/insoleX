//
//  QMLImagePickerManager.m
//  testQMLKit
//
//  Created by Myron on 16/3/31.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLImagePickerManager.h"
#import "QMLActionSheet.h"
#import "QMLAlertView.h"

@implementation QMLImagePickerManager

-(void)presentCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing = self.canEdit;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        UIViewController *vc = KEY_WINDOW.rootViewController;
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        [vc presentViewController:picker animated:YES completion:nil];
    }else{
        NSArray *actions = @[
                             [[QMLAlertAction alloc] initWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:COLOR_WITH_RGB(249, 98, 98)}] handle:nil],
                             ];
        QMLAlertView *al = [[QMLAlertView alloc] initWithTitle:@"提示" msg:@"设备不支持！" actions:actions];
        [al show];
    }
}
-(void)presentSavedPhotosAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate=self;
        picker.allowsEditing = self.canEdit;
        UIViewController *vc = KEY_WINDOW.rootViewController;
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        [vc presentViewController:picker animated:YES completion:nil];
    }else{
        NSArray *actions = @[
                             [[QMLAlertAction alloc] initWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:COLOR_WITH_RGB(249, 98, 98)}] handle:nil],
                             ];
        QMLAlertView *al = [[QMLAlertView alloc] initWithTitle:@"提示" msg:@"设备不支持！" actions:actions];
        [al show];
    }
}
-(void)showActionSheet{
    QMLActionSheet *sheet = [[QMLActionSheet alloc] init];
    [sheet setContent:nil texts:@[@"照相",@"相册"]];
    sheet.cancelText = @"取消";
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
    __weak typeof(self)bSelf = self;
    sheet.didSelectContent = ^(UIImage *img,NSString *text,int index,BOOL *dismiss){
        if (index==0) {
            [bSelf presentCamera];
        }
        if (index==1) {
            [bSelf presentSavedPhotosAlbum];
        }
    };
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if (self.didSelectedImage) {
        self.didSelectedImage(image);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (self.willShowImagePicker) {
        self.willShowImagePicker();
    }
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (self.didShowImagePicker) {
        self.didShowImagePicker();
    }
}
@end
