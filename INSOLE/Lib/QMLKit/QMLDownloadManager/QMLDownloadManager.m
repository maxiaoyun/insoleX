//
//  QMLDownloadManager.m
//  USENSE
//
//  Created by Myron on 16/5/30.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLDownloadManager.h"
#import "QMLUnit.h"

@interface QMLDownloadManager ()<NSURLConnectionDataDelegate>
{
    NSMutableDictionary *state_dict;
    NSMutableDictionary *info_dict;
}
@end
@implementation QMLDownloadManager
+(QMLDownloadManager *)sharedManager{
    static QMLDownloadManager *s_QMLDownloadManager_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_QMLDownloadManager_sharedInstance = [[QMLDownloadManager alloc] init];
    });
    return s_QMLDownloadManager_sharedInstance;
}
-(QMLDownloadState)downloadStateWithUrl:(NSURL *)url{
    if (!url) {
        return QMLDownloadStateUnBegin;
    }
    if (!state_dict) {
        [self readStateDictFromDisk];
    }
    NSString *fileName = [QMLUnit md5:[url description]];
    QMLDownloadState state = [[state_dict objectForKey:fileName] intValue];
    NSString *filePath = [self localPathWithUrl:url];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        state = QMLDownloadStateUnBegin;
        [state_dict setObject:@(state) forKey:fileName];
        [self saveStateDict];
    }
    return state;
}
-(void)saveStateDict{
    if (!self.downloadFolderPath) {
        self.downloadFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/QMLDownload"];
    }
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.downloadFolderPath isDirectory:&isDirectory];
    if (!exist||!isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *stateDictPath = [self.downloadFolderPath stringByAppendingPathComponent:@"download_state_info.plist"];
    [state_dict writeToFile:stateDictPath atomically:YES];
    
}
-(void)readStateDictFromDisk{
    if (!self.downloadFolderPath) {
        self.downloadFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/QMLDownload"];
    }
    NSString *stateDictPath = [self.downloadFolderPath stringByAppendingPathComponent:@"download_state_info.plist"];
    state_dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:stateDictPath]]];
    if (!state_dict) {
        state_dict = [NSMutableDictionary dictionary];
    }
}
-(NSString *)localPathWithUrl:(NSURL *)url{
    if (!url) {
        return nil;
    }
    NSString *extName = [[[url description] componentsSeparatedByString:@"."] lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[QMLUnit md5:[url description]],extName];
    NSString *filePath = [self.downloadFolderPath stringByAppendingPathComponent:fileName];
    return filePath;
}
-(NSString *)downloadWithUrl:(NSURL *)url{
    if (!url) {
        return nil;
    }
    if (!state_dict) {
        [self readStateDictFromDisk];
    }
    if (!self.downloadFolderPath) {
        self.downloadFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/QMLDownload"];
    }
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self.downloadFolderPath isDirectory:&isDirectory];
    if (!exist||!isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *fileName = [QMLUnit md5:[url description]];
    QMLDownloadState state = [[state_dict objectForKey:fileName] intValue];
    NSString *filePath = [self localPathWithUrl:url];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        state = QMLDownloadStateUnBegin;
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else{
        if (state == QMLDownloadStateFinished) {
            return fileName;
        }
    }
    if (!info_dict) {
        info_dict = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *infoDict = [info_dict objectForKey:url];
    NSMutableDictionary *dict = nil;
    if (infoDict) {
        dict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
    }else{
        dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                               @"fileName":fileName,
                                                               @"filePath":filePath,
                                                               @"fileURL":url,
                                                               }];
    }
    NSURLConnection *connection = [dict objectForKey:@"connection"];
    if (!connection) {
        state = QMLDownloadStateUnBegin;
        [self saveStateDict];
    }else{
        return fileName;
    }
    
    
    
    unsigned long long fileLen = [[NSData dataWithContentsOfFile:filePath] length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    NSString *rangeValue = [NSString stringWithFormat:@"bytes=%llu-", fileLen];
    [request addValue:rangeValue forHTTPHeaderField:@"Range"];
    
    [dict setObject:@(fileLen) forKey:@"fileLen"];
    [dict setObject:connection forKey:@"connection"];
    
    [connection start];
    [info_dict setObject:dict forKey:url];
    
    return fileName;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSURL *url = [connection.currentRequest URL];
    NSDictionary *dict = [info_dict objectForKey:url];
    NSFileHandle *handle = [dict objectForKey:@"fileHandle"];
    [handle closeFile];
    [info_dict removeObjectForKey:url];
    NSString *fileName = [dict objectForKey:@"fileName"];
    [state_dict setObject:@(QMLDownloadStateUnBegin) forKey:fileName];
    [self saveStateDict];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [connection.currentRequest URL];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:[info_dict objectForKey:url]];
    NSString *filePath = [infoDict objectForKey:@"filePath"];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (handle) {
        [infoDict setObject:handle forKey:@"fileHandle"];
        [info_dict setObject:infoDict forKey:url];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSURL *url = [connection.currentRequest URL];
    NSDictionary *dict = [info_dict objectForKey:url];
    NSFileHandle *handle = [dict objectForKey:@"fileHandle"];
    if (handle) {
        [handle seekToEndOfFile];
        [handle writeData:data];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURL *url = [connection.currentRequest URL];
    NSDictionary *dict = [info_dict objectForKey:url];
    NSFileHandle *handle = [dict objectForKey:@"fileHandle"];
    [handle closeFile];
    [info_dict removeObjectForKey:url];
    NSString *fileName = [dict objectForKey:@"fileName"];
    [state_dict setObject:@(QMLDownloadStateFinished) forKey:fileName];
    [self saveStateDict];
}





@end
