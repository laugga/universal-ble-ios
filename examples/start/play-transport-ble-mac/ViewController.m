//
//  ViewController.m
//  play-transport-ble-mac
//
//  Created by Luis Laugga on 02.11.15.
//  Copyright © 2015 Luis Laugga. All rights reserved.
//

#import "ViewController.h"

#import "UniversalBle.h"

@interface ViewController () <NSTextViewDelegate, UniversalBleDelegate>

@property (nonatomic, strong) UniversalBle * UniversalBle;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.string = @"NOT\nCONNECTED";
    self.textView.editable = NO;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    self.UniversalBle = [[UniversalBle alloc] init];
    self.UniversalBle.delegate = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.UniversalBle startAdvertising];
    });
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark -
#pragma mark UniversalBleDelegate

- (void)UniversalBleDidConnect:(UniversalBle *)UniversalBle
{
    self.textView.string = @"CONNECTED";
    self.textView.editable = YES;
}

- (void)UniversalBleDidDisconnect:(UniversalBle *)UniversalBle
{
    self.textView.string = @"NOT\nCONNECTED";
    self.textView.editable = NO;
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBle:didUpdateRSSI: %@", RSSI);
    
    //self.debubL
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didReceiveObject:(NSDictionary *)object
{
    NSDictionary * message = object[@"message"];
    if (message) {
        NSString * text = message[@"text"];
        self.textView.string = text;
    }
}

#pragma mark -
#pragma mark NSTextViewDelegate

- (void)textDidChange:(NSNotification *)notification
{
    NSTextView *textView = [notification object];
    [textView setString:[[textView string] uppercaseString]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.UniversalBle sendObject:@{@"type":@"message",@"message":@{@"text":textView.string, @"from":@"mac"}}];
    });
}

@end
