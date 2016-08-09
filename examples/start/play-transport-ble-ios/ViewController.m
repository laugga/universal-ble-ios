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
@property (nonatomic, weak) IBOutlet UILabel *pongLabel;
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
    NSString * text = object[@"msg"];
    if (text) {
        self.pongLabel.text = text;
        self.pongLabel.alpha = 1.0;
        [UIView animateWithDuration:1.0 animations:^{
            self.pongLabel.alpha = 0.0f;
        }];
    } else {
        self.pongLabel.text = [NSString stringWithFormat:@"Object: %@", [object description]];
    }
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBle:didUpdateRSSI: %@", RSSI);
    
    self.debugLabel.text = [NSString stringWithFormat:@"RSSI (%.1f dB)", RSSI.floatValue];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (IBAction)ping:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.UniversalBle sendObject:@{@"type":@"message",@"message":@{@"text":textView.text, @"from":@"mac"}}];
//    });
    
    [self.UniversalBle sendObject:@{@"msg":@"ping"}];
}


@end
