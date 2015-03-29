//
//  ViewController.m
//  FlightControl
//
//  Created by Colin Harris on 23/1/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "ConsoleViewController.h"
#import "AppDelegate.h"

@implementation ConsoleViewController

@synthesize textView, flightController;

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    self.flightController = appDelegate.flightController;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    flightController.delegate = self;
    [flightController connect];
}

- (void)flightControllerConsoleDidChange:(NSString *)value {
    [textView.textStorage.mutableString appendString:value];
    [textView scrollRangeToVisible: NSMakeRange(textView.string.length, 0)];
}

@end
