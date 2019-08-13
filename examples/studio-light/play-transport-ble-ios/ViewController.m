//
//  ViewController.m
//  play-transport-ble-ios
//
//  Created by Luis Laugga on 03.11.15.
//  Copyright © 2015 Luis Laugga. All rights reserved.
//

#import "ViewController.h"

#import "UniversalBluetooth.h"

@interface ViewController () <UniversalBluetoothDelegate, UITextViewDelegate>

@property (nonatomic, strong) UniversalBluetooth * UniversalBluetooth;

@property (nonatomic, weak) IBOutlet UIView * disconnectedView;
@property (nonatomic, weak) IBOutlet UIView * disconnectedMessageLabel;
@property (nonatomic, weak) IBOutlet UIView * connectingView;
@property (nonatomic, weak) IBOutlet UIView * connectedView;
@property (nonatomic, weak) IBOutlet UILabel * hueLabel;
@property (nonatomic, weak) IBOutlet UILabel * valueLabel;
@property (nonatomic, weak) IBOutlet UISlider * hueSlider;
@property (nonatomic, weak) IBOutlet UISlider * valueSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showDisconnectedView];
    
    self.UniversalBluetooth = [[UniversalBluetooth alloc] init];
    self.UniversalBluetooth.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.UniversalBluetooth start];
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
#pragma mark Actions

- (IBAction)didUpdateHue:(UISlider *)slider
{
    int hue = (int)slider.value;
    self.hueLabel.text = [NSString stringWithFormat:@"h %d", hue];
    
    // Send HV
    NSMutableDictionary * hv = [[NSMutableDictionary alloc] init];
    hv[@"h"] = [[NSNumber alloc] initWithInt:hue];
    int value = (int)self.valueSlider.value;
    hv[@"v"] = [[NSNumber alloc] initWithInt:value];
    [self.UniversalBluetooth sendObject:hv];
}

- (IBAction)didUpdateValue:(UISlider *)slider
{
    int value = (int)slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"v %d", value];
    
    // Send HV
    NSMutableDictionary * hv = [[NSMutableDictionary alloc] init];
    hv[@"v"] = [[NSNumber alloc] initWithInt:value];
    int hue = (int)self.hueSlider.value;
    hv[@"h"] = [[NSNumber alloc] initWithInt:hue];
    [self.UniversalBluetooth sendObject:hv];
}

#pragma mark -
#pragma mark UniversalBluetoothDelegate

- (void)UniversalBluetoothDidConnect:(UniversalBluetooth *)UniversalBluetooth
{
    [self showConnectingView];
}

- (void)UniversalBluetoothDidDisconnect:(UniversalBluetooth *)UniversalBluetooth
{
    [self showDisconnectedView];
}

- (void)UniversalBluetooth:(UniversalBluetooth *)UniversalBluetooth didReceiveObject:(NSDictionary *)object
{
    NSNumber * hvHue = object[@"h"];
    NSNumber * hvValue = object[@"v"];
    
    if (hvHue) {
        int hue = hvHue.intValue;
        self.hueLabel.text = [NSString stringWithFormat:@"h %d", hue];
        self.hueSlider.value = (float)hue;
    }
    
    if (hvValue) {
        int value = hvValue.intValue;
        self.valueLabel.text = [NSString stringWithFormat:@"v %d", value];
        self.valueSlider.value = (float)value;
    }
}

- (void)UniversalBluetooth:(UniversalBluetooth *)UniversalBluetooth didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBluetooth:didUpdateRSSI: %@", RSSI);
}

@end
