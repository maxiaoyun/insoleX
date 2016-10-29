//
//  QMLTouchView.m
//  USENSE
//
//  Created by Myron on 16/1/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLTouchView.h"

@implementation QMLTouchView
@synthesize touchesBegan,touchesMoved,touchesEnded,touchesCancelled,nextRes;

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchesBegan) {
        self.touchesBegan(touches,event);
    }
    if (self.nextRes) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchesMoved) {
        self.touchesMoved(touches,event);
    }
    if (self.nextRes) {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchesEnded) {
        self.touchesEnded(touches,event);
    }
    if (self.nextRes) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchesCancelled) {
        self.touchesCancelled(touches,event);
    }
    if (self.nextRes) {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
}
@end
