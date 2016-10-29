//
//  QMLAVPlayerManager.m
//  testQMLKit
//
//  Created by Myron on 16/4/12.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLAVPlayerManager.h"
@interface QMLAVPlayerManager()
{
    AVQueuePlayer *queuePlayer;
    BOOL isPlaying;
}
@end
@implementation QMLAVPlayerManager
+(QMLAVPlayerManager *)sharedManager{
    static QMLAVPlayerManager *s_QMLAVPlayerManager_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_QMLAVPlayerManager_sharedInstance = [[QMLAVPlayerManager alloc] init];
    });
    return s_QMLAVPlayerManager_sharedInstance;
}
-(id)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)playWithUrl:(NSURL *)url{
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    if (!queuePlayer) {
        queuePlayer = [[AVQueuePlayer alloc] initWithItems:@[item]];
        [queuePlayer play];
    }else{
        AVPlayerItem *currentItem = [queuePlayer currentItem];
        [queuePlayer insertItem:item afterItem:currentItem];
        [queuePlayer advanceToNextItem];
    }
    isPlaying = YES;
}
-(BOOL)playing{
    return isPlaying;
}
-(void)play{
    [queuePlayer play];
    isPlaying = YES;
}
-(void)pause{
    [queuePlayer pause];
    isPlaying = NO;
}
@end
