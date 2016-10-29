//
//  QMLPeripheral.h
//  UBCBTTools
//
//  Created by Myron on 15/7/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface QMLPeripheral : QMLObj
/**
 *  外设
 */
@property(nonatomic,strong)CBPeripheral *peripheral;

@property(nonatomic,strong)NSNumber *RSSI;
@property(nonatomic,readonly)NSString *identifier __attribute__((unavailable("废弃 使用flag替代")));
@property(nonatomic,copy)NSString *name;
/**
 *  广播数据
 */
@property(nonatomic,strong)NSDictionary *advertisementData;
/**
 *  外设当前状态
 */
@property(nonatomic,readonly)CBPeripheralState state;
@property(nonatomic,strong)NSDictionary *userInfo;
-(id)initWithPeripheral:(CBPeripheral *)peripheral;
/**
 *  写入数据
 *
 *  @param data 写入的数据
 */
-(void)writeData:(NSData *)data;
@end

/**
 *  接收从外设发来的到数据
 */
const static NSString *NOT_NAME_CHAR_REV_DATA      = @"NOT_NAME_CHAR_REV_DATA";