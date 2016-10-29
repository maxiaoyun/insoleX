//
//  QMLCalendarCell.m
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLCalendarCell.h"
#import "QMLCalendarItem.h"
@interface QMLCalendarCell()
{
    float i_w;
    CGPoint beginPoint;
}
@end
@implementation QMLCalendarCell
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    beginPoint = [touch locationInView:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self];
    float distance = sqrtf(powf(beginPoint.x-endPoint.x, 2)+powf(beginPoint.y-endPoint.y, 2));
    if (distance<10) {
        if (self.cellClick) {
            UITouch *touch=[touches anyObject];
            CGPoint p=[touch locationInView:self];
            int index=p.x/i_w;
            if (index>6) {
                index=6;
            }
            self.cellClick(index);
        }
    }
}
-(void)setupDefineValues{
    [super setupDefineValues];
}
-(void)drawRect:(CGRect)rect{
    float w = rect.size.width;
    float h = rect.size.height;
    i_w = w/7;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    for (int i=0; i<self.items.count; i++) {
        QMLCalendarItem *item = [self.items objectAtIndex:i];
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, item.bgColor.CGColor);
        CGRect i_rect = CGRectMake(i_w*i, 0, i_w, h);
        CGContextFillRect(ctx, i_rect);
        CGContextDrawPath(ctx, kCGPathFill);
        int day = [item.title intValue];
        switch (self.type) {
            case QMLCalendarCellTypeNormal:
                [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.titleColor}];
                break;
            case QMLCalendarCellTypeLastWeek:
                if (day<7) {
                    [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.otherTitleColor}];
                }else{
                    [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.titleColor}];
                }
                break;
            case QMLCalendarCellTypeFirstWeek:
                if (day>7) {
                    [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.otherTitleColor}];
                }else{
                    [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.titleColor}];
                }
                break;
                
            default:
                [item.title drawInRect:CGRectMake(i_w*i, (h-item.font.lineHeight)/2, i_w, item.font.lineHeight) withAttributes:@{NSFontAttributeName:item.font,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:item.titleColor}];
                break;
        }
        CGContextRestoreGState(ctx);
    }
}
@end
