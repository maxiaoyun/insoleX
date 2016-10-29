//
//  QMLDownloadManager.h
//  USENSE
//
//  Created by Myron on 16/5/30.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLObj.h"
typedef enum QMLDownloadState{
    QMLDownloadStateUnBegin          = 0,
    QMLDownloadStateDownloading      = 1,
    QMLDownloadStateFinished         = 2,
}QMLDownloadState;
@interface QMLDownloadManager : QMLObj
@property(nonatomic,copy)NSString *downloadFolderPath;
+(QMLDownloadManager *)sharedManager;
-(NSString *)downloadWithUrl:(NSURL *)url;
-(NSString *)localPathWithUrl:(NSURL *)url;
-(QMLDownloadState)downloadStateWithUrl:(NSURL *)url;
@end
