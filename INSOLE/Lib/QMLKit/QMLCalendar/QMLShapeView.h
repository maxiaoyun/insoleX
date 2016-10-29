//
//  QMLShapeView.h
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLView.h"
enum QMLTouchEventType:NSUInteger{
    QMLTouchEventBegan,
    QMLTouchEventMoved,
    QMLTouchEventEnded,
    QMLTouchEventCanceled,
};
typedef enum QMLTouchEventType QMLTouchEventType;
@interface QMLShapeView : QMLView
@property(nonatomic,copy)void(^touchEvent)(NSSet<UITouch *> *touches,UIEvent *event,QMLTouchEventType eventType);
@end
