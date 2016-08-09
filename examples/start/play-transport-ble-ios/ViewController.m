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
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *debugLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = @"NOT\nCONNECTED";
    self.textView.editable = NO;
    
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
    self.textView.text = @"CONNECTED";
    self.textView.editable = YES;
}

- (void)UniversalBleDidDisconnect:(UniversalBle *)UniversalBle
{
    self.textView.text = @"NOT\nCONNECTED";
    self.textView.editable = NO;
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didReceiveObject:(NSDictionary *)object
{
    NSDictionary * message = object[@"message"];
    if (message) {
        NSString * text = message[@"text"];
        self.textView.text = text;
    } else {
        self.textView.text = [NSString stringWithFormat:@"Object: %@", [object description]];
    }
}

- (void)UniversalBle:(UniversalBle *)UniversalBle didUpdateRSSI:(NSNumber *)RSSI
{
    NSLog(@"UniversalBle:didUpdateRSSI: %@", RSSI);
    
    self.debugLabel.text = [NSString stringWithFormat:@"RSSI (%.1f dB)", RSSI.floatValue];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [textView setText:[[textView text] uppercaseString]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.UniversalBle sendObject:@{@"type":@"message",@"message":@{@"text":textView.text, @"from":@"mac"}}];
    });
}


@end
