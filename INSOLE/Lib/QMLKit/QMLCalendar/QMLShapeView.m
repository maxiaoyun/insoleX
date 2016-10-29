//
//  QMLShapeView.m
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLShapeView.h"

@implementation QMLShapeView

+(Class)layerClass{
    return [CAShapeLayer class];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.touchEvent){
        self.touchEvent(touches,event,QMLTouchEventBegan);
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.touchEvent){
        self.touchEvent(touches,event,QMLTouchEventMoved);
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.touchEvent){
        self.touchEvent(touches,event,QMLTouchEventCanceled);
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.touchEvent){
        self.touchEvent(touches,event,QMLTouchEventEnded);
    }
}
@end
