//
//  QMLStatusImageView.h
//  testYJLUIKit
//
//  Created by user on 14-10-5.
//  Copyright (c) 2014年 钟园园. All rights reserved.
//

#import "QMLTouchImageView.h"

@interface QMLStatusImageView : QMLTouchImageView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIImage *defaultImg;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIImage *selectImg;
@property(nonatomic,assign)BOOL    selected;
@end
