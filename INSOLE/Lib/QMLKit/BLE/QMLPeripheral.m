//
//  QMLPeripheral.m
//  UBCBTTools
//
//  Created by Myron on 15/7/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLPeripheral.h"
#import "QMLCBManager.h"
#import "QMLLog.h"
#import "NSObject+flag.h"
@interface QMLPeripheral ()<CBPeripheralDelegate>
{
    NSMutableArray *writeCharArr;
}
@property(nonatomic,strong)CBCharacteristic *writeCharacteristic;
@end
@implementation QMLPeripheral
-(id)initWithPeripheral:(CBPeripheral *)peripheral{
    if (self = [super init]) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        self.flag = [self getIdentifier];
        [self.peripheral readRSSI];
    }
    return self;
}
-(CBPeripheralState)state{
    return self.peripheral.state;
}

-(NSString *)getIdentifier{
    NSUUID *uuid = [self.peripheral identifier];
    return [uuid UUIDString];
}
-(NSArray *)characteristicGetProperty:(CBCharacteristic *)character{
    NSMutableArray *arr = [NSMutableArray array];
    NSUInteger pro = character.properties;
    for (int i=0; i<32; i++) {
        NSUInteger b = 1<<i;
        if ((pro&b)>0) {
            [arr addObject:@(b)];
        }
    }
    return arr;
}
-(CBCharacteristic *)getWriteCharacteristic{
    if (self.writeCharacteristic) {
        return self.writeCharacteristic;
    }
    if (!writeCharArr||writeCharArr.count==0) {
        writeCharArr = [NSMutableArray array];
        for (CBService *service in self.peripheral.services) {
            for (CBCharacteristic *character in service.characteristics) {
                NSArray *properties = [self characteristicGetProperty:character];
                if ([properties containsObject:@(CBCharacteristicPropertyWriteWithoutResponse)]) {
                    if ([[QMLCBManager sharedManager].writeCharacteristicUUIDStrings containsObject:character.UUID.UUIDString ]) {
                        [writeCharArr addObject:character];
                    }
                }
            }
        }
        for (CBService *service in self.peripheral.services) {
            for (CBCharacteristic *character in service.characteristics) {
                NSArray *properties = [self characteristicGetProperty:character];
                if ([properties containsObject:@(CBCharacteristicPropertyWrite)]) {
                    if ([[QMLCBManager sharedManager].writeCharacteristicUUIDStrings containsObject:character.UUID.UUIDString ]) {
                        [writeCharArr addObject:character];
                    }
                }
            }
        }
    }
    
    if (writeCharArr.count>0) {
        self.writeCharacteristic = [writeCharArr objectAtIndex:0];
        return  self.writeCharacteristic;
    }
    return nil;
}
-(void)writeData:(NSData *)data{
    CBCharacteristic *characteristic = [self getWriteCharacteristic];
    if (!characteristic) {
        QMLog(@"找不到写特征");
        return;
    }
    
    CBCharacteristicWriteType type = CBCharacteristicWriteWithoutResponse;
    NSArray *properties = [self characteristicGetProperty:characteristic];
    if (![properties containsObject:@(CBCharacteristicPropertyWriteWithoutResponse)]) {
        type = CBCharacteristicWriteWithResponse;
    }
    char emptyData[10] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
    NSMutableData *muData = [NSMutableData dataWithBytes:emptyData length:10];
    [muData appendData:data];
    [self.peripheral writeValue:muData forCharacteristic:characteristic type:type];
    QMLog(@"写入特征：%@",characteristic.UUID.UUIDString);
    QMLog(@"写入数据：%@",data);
    
    
}



-(void)postNotifity:(const NSString *)notName object:(id)object userInfo:(NSDictionary *)userInfo{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)notName object:object userInfo:userInfo];
    });
}

#pragma mark  -- CBPeripheralDelegate Methods 
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral{
    _name = peripheral.name;
}
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error{
    _RSSI = peripheral.RSSI;
}
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    _RSSI = RSSI;
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
//    if (error) {
//        [writeCharArr removeObject:characteristic];
//    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [self postNotifity:NOT_NAME_CHAR_REV_DATA object:characteristic.value userInfo:@{@"characteristic":characteristic,@"peripheral":peripheral,@"port":self}];
    QMLog(@"接受到数据：%@  特征 %@",characteristic.value,characteristic.UUID.UUIDString);
}
@end

