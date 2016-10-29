//
//  QMLTouchView.h
//  USENSE
//
//  Created by Myron on 16/1/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLView.h"


@protocol QMLTouchProtocol <NSObject>

@property(nonatomic,copy)void(^touchesBegan)(NSSet<UITouch *> *touches,UIEvent *event);
@property(nonatomic,copy)void(^touchesMoved)(NSSet<UITouch *> *touches,UIEvent *event);
@property(nonatomic,copy)void(^touchesCancelled)(NSSet<UITouch *> *touches,UIEvent *event);
@property(nonatomic,copy)void(^touchesEnded)(NSSet<UITouch *> *touches,UIEvent *event);
@property(nonatomic,assign)BOOL nextRes;
@end

@interface QMLTouchView : QMLView<QMLTouchProtocol>

@end

