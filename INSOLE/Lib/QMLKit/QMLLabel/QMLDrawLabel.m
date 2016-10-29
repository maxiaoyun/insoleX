//
//  QMLDrawLabel.m
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLDrawLabel.h"
#import "QMLUnit.h"
#import "QMLLog.h"

@implementation QMLDrawLabel
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
    
#else
    [_textColor release];
    [_text release];
    [_font release];
    [super dealloc];
#endif
}
-(void)setupDefineValues
{
    [super setupDefineValues];
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:15];
}
-(float)width
{
    NSString *drawStr=[self getDrawString:self.text];
    return [drawStr sizeWithAttributes:@{
                                         NSFontAttributeName:self.font
                                         }].width;
}
-(NSString *)getDrawString:(NSString *)string
{
    return [QMLUnit stringByDelWhitespaceAndNewLine:string];
}
-(void)adjustFrame
{
    CGRect rect=self.frame;
    rect.size.width=self.width;
    self.frame=rect;
}
-(void)redraw
{
    [self adjustFrame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSString *drawStr=[self getDrawString:self.text];
    UIFont   *font=self.font;
    UIColor  *color=self.textColor;
    float height = [drawStr sizeWithAttributes:@{
                                                 NSFontAttributeName:font
                                                 }].height;
    float y=(rect.size.height-height)/2;
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(ctx);
    
    CGContextSaveGState(ctx);
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    [color setFill];
    [drawStr drawInRect:CGRectMake(0, y, self.width, height) withAttributes:@{
                                                                              NSFontAttributeName:font
                                                                              }];
    CGContextRestoreGState(ctx);
    
    UIGraphicsPopContext();
    
}

@end
