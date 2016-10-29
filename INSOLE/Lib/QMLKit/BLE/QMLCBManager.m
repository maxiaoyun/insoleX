//
//  QMLCBManager.m
//  UBCBTTools
//
//  Created by Myron on 15/7/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLCBManager.h"
#import "QMLPeripheral.h"
#import "NSObject+flag.h"
@interface QMLCBManager ()<CBCentralManagerDelegate>
{
    CBCentralManager *cbManager;
    NSMutableDictionary *connectingPort;
    NSMutableDictionary *connectedPort;
}
@property(nonatomic,strong)NSArray *CBUUIDS;
@end
@implementation QMLCBManager
+(QMLCBManager *)sharedManager{
    static QMLCBManager *s_QMLCBManager_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_QMLCBManager_sharedInstance = [[QMLCBManager alloc] init];
    });
    return s_QMLCBManager_sharedInstance;
}
-(id)init{
    if (self = [super init]) {
        cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        connectingPort = [NSMutableDictionary dictionary];
        connectedPort = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)searchForUUID:(NSArray*)UUIDStrings{
    
    NSMutableArray *UUIDS = [NSMutableArray array];
    for (NSString *uuidString in UUIDStrings) {
        CBUUID *uuid = [CBUUID UUIDWithString:uuidString];
        if (uuid) {
            [UUIDS addObject:uuid];
        }
    }
    if (UUIDS.count>0) {
        self.CBUUIDS = [NSArray arrayWithArray:UUIDS];
        [cbManager stopScan];
        [cbManager scanForPeripheralsWithServices:UUIDS options:nil];
    }else{
        [cbManager stopScan];
        [cbManager scanForPeripheralsWithServices:nil options:nil];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop) object:nil];
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:300];
}
-(void)stopScan{
    [cbManager stopScan];
}
-(void)connectPeripheral:(QMLPeripheral*)peripheral{
    [connectingPort setObject:peripheral forKey:peripheral.peripheral];
    [cbManager connectPeripheral:peripheral.peripheral options:nil];
}
-(void)disconnectPeripheral:(QMLPeripheral*)peripheral{
    [cbManager cancelPeripheralConnection:peripheral.peripheral];
}
-(NSArray *)getCurrentConnectedPort{
    return [connectedPort allValues];
}
-(QMLPeripheral *)getConnectedPortWithFlag:(NSString *)flag{
    for (QMLPeripheral *port in [self getCurrentConnectedPort]) {
        if ([port.flag isEqualToString:flag]) {
            return port;
        }
    }
    return nil;
}


-(void)postNotifity:(const NSString *)notName object:(id)object{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)notName object:object];
    });
}
#pragma  mark -- CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [self postNotifity:NOT_NAME_CB_STATE_UPDATE object:@(central.state)];
    if(central.state==CBCentralManagerStatePoweredOn){
        [cbManager stopScan];
        [cbManager scanForPeripheralsWithServices:self.CBUUIDS options:nil];
    }else{
        [cbManager stopScan];
        [connectedPort removeAllObjects];
        [connectingPort removeAllObjects];
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    QMLPeripheral *port = [[QMLPeripheral alloc] initWithPeripheral:peripheral];
    port.RSSI = RSSI;
    port.advertisementData = advertisementData;
    port.name = peripheral.name;
    NSString *adName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    if (adName) {
        port.name = adName;
    }
    [self postNotifity:NOT_NAME_CB_DISCOVER_PORT object:port];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    QMLPeripheral *port = [connectingPort objectForKey:peripheral];
    [peripheral discoverServices:nil];
    
    [self postNotifity:NOT_NAME_CB_CONNECT_PORT_SUCCESS object:port];
    [connectedPort setObject:port forKey:peripheral];
    [connectingPort removeObjectForKey:peripheral];
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self postNotifity:NOT_NAME_CB_CONNECT_PORT_FAILURE object:[connectingPort objectForKey:peripheral]];
    [connectingPort removeObjectForKey:peripheral];
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    QMLPeripheral *port = [connectingPort objectForKey:peripheral];
    if (port==NULL) {
        port = [connectedPort objectForKey:peripheral];
    }
    [self postNotifity:NOT_NAME_CB_DISCONNECT_PORT object:port];
    [connectedPort removeObjectForKey:peripheral];
    [connectingPort removeObjectForKey:peripheral];
}
@end
