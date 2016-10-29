//
//  QMLTextView.h
//  testQMLKit
//
//  Created by Myron on 15/1/20.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QMLTextView : UITextView
@property(nonatomic,copy)NSString *placeholder;
-(void)textChanged;

-(void)setupDefineValues;
- (NSUInteger)numberOfLines;
@end
