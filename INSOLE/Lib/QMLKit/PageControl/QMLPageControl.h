//
//  QMLPageControl.h
//  testQMLKit
//
//  Created by Myron on 16/4/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLView.h"

@interface QMLPageControl : QMLView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *pageIndicatorTintColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *currentPageIndicatorTintColor;
@property(nonatomic,assign)int numberOfPages;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)int hidesForSinglePage;
@property(nonatomic,assign)QMLPosition position;
@property(nonatomic,assign)float indicatorWidth;
@property(nonatomic,assign)float currentIndicatorWidth;
@end
