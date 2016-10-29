//
//  QMLStyle.m
//  testQMLKit
//
//  Created by Myron on 16/4/29.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLStyle.h"
@interface QMLStyle()
{
    
}
@end

@implementation QMLStyle
-(void)setFrame:(CGRect)frame{
    _frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}
-(void)setCenter:(CGPoint)center{
    _center = CGPointMake(center.x, center.y);
}
-(void)setShadowOffset:(CGSize)shadowOffset{
    _shadowOffset = CGSizeMake(shadowOffset.width, shadowOffset.height);
}
@end


@implementation UIView (QMLStyle)
+(UIView *)viewWithStyle:(QMLStyle *)style{
    UIView *view = [[[self class] alloc] initWithFrame:style.frame];
    view.backgroundColor = style.backgroundColor;
    if (style.borderColor) {
        view.layer.borderColor = style.borderColor.CGColor;
        view.layer.borderWidth = style.borderWidth;
        view.layer.cornerRadius = style.cornerRadius;
    }
    if (style.shadowColor) {
        view.layer.shadowColor = style.shadowColor.CGColor;
        view.layer.shadowRadius = style.shadowRadius;
        view.layer.shadowOpacity = style.shadowOpacity;
        view.layer.shadowOffset = style.shadowOffset;
    }
    view.center = style.center;
    return view;
}


@end
