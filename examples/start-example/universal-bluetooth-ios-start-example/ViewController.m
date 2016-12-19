//
//  ViewController.m
//  UniversalBluetooth
//
//  Created by Luis Laugga on 03.11.15.
//  Copyright © 2015 Luis Laugga. All rights reserved.
//

#import "ViewController.h"

#import <UniversalBluetooth/UniversalBluetooth.h>

@interface ViewController () <UniversalBluetoothDelegate, UITextViewDelegate>

@property (nonatomic, strong) UniversalBluetooth * UniversalBluetooth;

@property (nonatomic, weak) IBOutlet UITextView * textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.text = @"Not connected. Bring the other device closer...";
    self.textView.delegate = self;
    
    self.UniversalBluetooth = [[UniversalBluetooth alloc] init];
    self.UniversalBluetooth.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.UniversalBluetooth startScanning];
    });
}

#pragma mark -
#pragma mark UniversalBluetoothDelegate

- (void)UniversalBluetoothDidConnect:(UniversalBluetooth *)UniversalBluetooth
{
    self.textView.text = @"Connected :)";
}

- (void)UniversalBluetoothDidDisconnect:(UniversalBluetooth *)UniversalBluetooth
{
    self.textView.text = @"Not connected. Bring the other device closer...";
}

- (void)UniversalBluetooth:(UniversalBluetooth *)UniversalBluetooth didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBluetooth:didUpdateRSSI: %@", RSSI);
}

- (void)UniversalBluetooth:(UniversalBluetooth *)UniversalBluetooth didReceiveObject:(NSDictionary *)object
{
    if ([object[@"type"] isEqualToString:@"message"])
    {
        self.textView.text = object[@"message"][@"text"];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.UniversalBluetooth sendObject:@{@"type":@"message",@"message":@{@"text":textView.text, @"from":@"iphone"}}];
}


@end
