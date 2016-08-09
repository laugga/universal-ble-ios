//
//  ViewController.m
//  play-transport-ble-ios
//
//  Created by Luis Laugga on 03.11.15.
//  Copyright © 2015 Luis Laugga. All rights reserved.
//

#import "ViewController.h"

#import "UniversalBle.h"

@interface ViewController () <UniversalBleDelegate, UITextViewDelegate>

@property (nonatomic, strong) UniversalBle * UniversalBle;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UILabel *debugLabel;
@property (nonatomic, weak) IBOutlet UILabel *luxValueLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stateLabel.text = @"NOT CONNECTED";
    
    self.UniversalBle = [[UniversalBle alloc] init];
    self.UniversalBle.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.UniversalBle startScanning];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UniversalBleDelegate

- (void)UniversalBleDidConnect:(UniversalBle *)UniversalBle
{
    self.stateLabel.text = @"CONNECTED";
}

- (void)UniversalBleDidDisconnect:(UniversalBle *)UniversalBle
{
    self.stateLabel.text = @"NOT CONNECTED";
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didReceiveObject:(NSDictionary *)object
{
    NSNumber * luxValue = object[@"lux"];
    if (luxValue) {
        self.luxValueLabel.text = [NSString stringWithFormat:@"%f lux", luxValue.floatValue];
    }
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBle:didUpdateRSSI: %@", RSSI);
    
    self.debugLabel.text = [NSString stringWithFormat:@"RSSI (%.1f dB)", RSSI.floatValue];
}

@end
