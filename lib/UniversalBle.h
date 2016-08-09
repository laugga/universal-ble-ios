//
//  UniversalBle.h
//  Universal
//
//  Created by Luis Laugga on 02.11.15.
//  Copyright © 2015 Luis Laugga. All rights reserved.
//

@import CoreBluetooth;

@protocol UniversalBleDelegate;

@interface UniversalBle : NSObject <CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>
{
    double _filteredRSSI; // Low-pass filter
}

@property (strong, nonatomic) CBCharacteristic * rxCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic * mutableRxCharacteristic;
@property (strong, nonatomic) CBCharacteristic * txCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic * mutableTxCharacteristic;
@property (strong, nonatomic) CBMutableService * service;

@property (nonatomic, strong) CBCentralManager * centralManager;
@property (nonatomic, strong) CBPeripheralManager * peripheralManager;

@property (nonatomic, strong) CBPeripheral * peripheral;

@property (nonatomic, weak) id<UniversalBleDelegate> delegate;

- (void)startAdvertising;
- (void)stopAdvertising;

- (void)startScanning;
- (void)stopScanning;

- (void)sendObject:(NSDictionary *)object;

@end

@protocol UniversalBleDelegate <NSObject>

- (void)UniversalBleDidConnect:(UniversalBle *)UniversalBle;
- (void)UniversalBleDidDisconnect:(UniversalBle *)UniversalBle;

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI;

- (void)UniversalBle:(UniversalBle *)UniversalBle didReceiveObject:(NSDictionary *)object;

@end
