//
//  QMLAVPlayerManager.h
//  testQMLKit
//
//  Created by Myron on 16/4/12.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import <AVFoundation/AVFoundation.h>
@interface QMLAVPlayerManager : QMLObj

+(QMLAVPlayerManager *)sharedManager;
-(void)playWithUrl:(NSURL *)url;
-(void)pause;
-(void)play;
-(BOOL)playing;
@end
