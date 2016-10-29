//
//  QMLLabel.h
//  QMLRecord
//
//  Created by Myron on 15/8/27.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMLObj.h"
@interface QMLLabel : UILabel
@property(nonatomic,copy)void(^tapAction)(void);
@end
