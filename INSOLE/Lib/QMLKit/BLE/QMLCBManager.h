//
//  QMLCBManager.h
//  UBCBTTools
//
//  Created by Myron on 15/7/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import <CoreBluetooth/CoreBluetooth.h>
@class QMLPeripheral;
@interface QMLCBManager : QMLObj
@property(readonly) CBCentralManagerState state;
@property(nonatomic,strong)NSArray *writeCharacteristicUUIDStrings;
+(QMLCBManager *)sharedManager;
/**
 *  搜索蓝牙
 *
 *  @param UUIDStrings UUID strings 为nil则为搜索所有
 */
-(void)searchForUUID:(NSArray*)UUIDStrings;
/**
 *  停止搜索蓝牙
 */
-(void)stopScan;

/**
 *  连接蓝牙
 *
 *  @param peripheral 需要连接的周边蓝牙外设
 */
-(void)connectPeripheral:(QMLPeripheral*)peripheral;
/**
 *  断开蓝牙
 *
 *  @param peripheral 需要断开的周边蓝牙外设
 */
-(void)disconnectPeripheral:(QMLPeripheral*)peripheral;
/**
 *  得到目前所有已经连接上的外设
 *
 *  @return 所有已经连接上的外设
 */
-(NSArray *)getCurrentConnectedPort;
/**
 *  通过外设的flag得到已经连接上的外设
 *
 *  @param flag 外设的flag
 *
 *  @return 对应flag的外设，没有找到则返回null
 */
-(QMLPeripheral *)getConnectedPortWithFlag:(NSString *)flag;
@end

/**
 *  中心设备状态发生变化
 */
const static NSString *NOT_NAME_CB_STATE_UPDATE         = @"NOT_NAME_CB_STATE_UPDATE";
/**
 *  中心设备扫描到外设
 */
const static NSString *NOT_NAME_CB_DISCOVER_PORT        = @"NOT_NAME_CB_DISCOVER_PORT";
/**
 *  中心设备连接外设成功
 */
const static NSString *NOT_NAME_CB_CONNECT_PORT_SUCCESS = @"NOT_NAME_CB_CONNECT_PORT_SUCCESS";
/**
 *  中心设备连接外设失败
 */
const static NSString *NOT_NAME_CB_CONNECT_PORT_FAILURE = @"NOT_NAME_CB_CONNECT_PORT_FAILURE";
/**
 *  中心设备端开了某个外设
 */
const static NSString *NOT_NAME_CB_DISCONNECT_PORT      = @"NOT_NAME_CB_DISCONNECT_PORT";
