//
//  QMLKit.h
//  QMLKit
//
//  Created by Myron on 15/8/5.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "NSObject+flag.h"
#import "QMLObj.h"
#import "QMLCBManager.h"
#import "QMLADControl.h"
#import "QMLPeripheral.h"
#import "QMLBarChartItem.h"
#import "QMLBarChartView.h"
#import "QMLCustomBarChartView.h"
#import "QMLInputView.h"
#import "QMLNetAction.h"
#import "QMLNetwork.h"
#import "QMLImageView.h"
#import "QMLShapeLayer.h"
#import "QMLTextView.h"
#import "QMLView.h"
#import "QMLViewController.h"
#import "UIImage+handle.h"
#import "UIImageView+imageLoader.h"
#import "UIScrollView+ref.h"
#import "QMLStatusImageView.h"
#import "QMLTouchImageView.h"
#import "QMLKit.h"
#import "QMLDrawLabel.h"
#import "QMLScrollLabel.h"
#import "QMLLayout.h"
#import "QMLLayoutFunction.h"
#import "QMLLog.h"
#import "QMLProgressView.h"
#import "QMLSegItem.h"
#import "QMLSegmentControl.h"
#import "QMLSlider.h"
#import "QMLUnit.h"
#import "QMLWaitingView.h"
#import "QMLWebHelper.h"
#import "QMLDropdownView.h"
#import "QMLLabel.h"
#import "QMLShapeView.h"
#import "QMLChartView.h"
#import "QMLCalendarCell.h"
#import "QMLCalendarItem.h"
#import "QMLCalendarView.h"
#import "QMLChartItem.h"
#import "QMLChartView.h"
#import "QMLActionSheet.h"
#import "QMLAlertView.h"
#import "QMLGradientView.h"
#import "QMLImagePickerManager.h"
#import "QMLAVPlayerManager.h"
#import "QMLPageControl.h"
#import "QMLPieChartView.h"
#import "QMLPieChartItem.h"
#import "QMLDownloadManager.h"

static NSString *QMLKitVersionString = @"1.0.4";


@interface QMLKit : NSObject


/**
 *	@brief	QMLKit Version
 *
 *	@return	Version string
 */
+(NSString *)versionForQMLKit;


@end
