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

@property (nonatomic, weak) IBOutlet UIView * disconnectedView;
@property (nonatomic, weak) IBOutlet UIView * disconnectedMessageLabel;
@property (nonatomic, weak) IBOutlet UIView * connectingView;
@property (nonatomic, weak) IBOutlet UIView * connectedView;
@property (nonatomic, weak) IBOutlet UILabel * luxLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showDisconnectedView];
    
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)showDisconnectedView
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedView.alpha = 1.0;
        self.connectingView.alpha = 0.0;
        self.connectedView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
    
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedMessageLabel.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
}

- (void)showConnectingView
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedMessageLabel.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
    
    [UIView animateWithDuration:0.5 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedView.alpha = 0.0;
        self.connectingView.alpha = 0.0;
        self.connectedView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
    
    [UIView animateWithDuration:0.5 delay:0.65 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedView.alpha = 0.0;
        self.connectingView.alpha = 1.0;
        self.connectedView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showConnectedView];
    });
}

- (void)showConnectedView
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedView.alpha = 0.0;
        self.connectingView.alpha = 0.0;
        self.connectedView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
    
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.disconnectedView.alpha = 0.0;
        self.connectingView.alpha = 0.0;
        self.connectedView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        // ...
    }];
}

#pragma mark -
#pragma mark UniversalBleDelegate

- (void)UniversalBleDidConnect:(UniversalBle *)UniversalBle
{
    [self showConnectingView];
}

- (void)UniversalBleDidDisconnect:(UniversalBle *)UniversalBle
{
    [self showDisconnectedView];
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didReceiveObject:(NSDictionary *)object
{
    NSNumber * luxValue = object[@"lux"];
    if (luxValue) {
        self.luxLabel.text = [NSString stringWithFormat:@"%.0f lx", luxValue.floatValue];
    }
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBle:didUpdateRSSI: %@", RSSI);
}

@end
