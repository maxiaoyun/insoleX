//
//  QMLPhotoCollectionCell.h
//  testQMLKit
//
//  Created by Myron on 15/11/9.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMLPhotoCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImage *tintImage;
-(void)makeTintImgCenter;
@end
