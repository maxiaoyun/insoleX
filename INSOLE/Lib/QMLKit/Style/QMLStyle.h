//
//  QMLStyle.h
//  testQMLKit
//
//  Created by Myron on 16/4/29.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QMLStyle : NSObject
@property(nonatomic,strong)UIColor *backgroundColor;

@property(nonatomic,assign)CGRect frame;
@property(nonatomic,assign)CGPoint center;

@property(nonatomic,strong)UIColor *borderColor;
@property(nonatomic,assign)CGFloat borderWidth;
@property(nonatomic,assign)CGFloat cornerRadius;

@property(nonatomic,strong)UIColor *shadowColor;
@property(nonatomic,assign)float shadowOpacity;
@property(nonatomic,assign)CGFloat shadowRadius;
@property(nonatomic,assign)CGSize shadowOffset;
@end
@interface UIView (QMLStyle)
+(UIView *)viewWithStyle:(QMLStyle *)style;
@end
