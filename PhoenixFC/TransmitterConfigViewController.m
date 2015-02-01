//
//  TransmitterConfigViewController.m
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "TransmitterConfigViewController.h"
#import "AppDelegate.h"

@interface TransmitterConfigViewController ()

@end

@implementation TransmitterConfigViewController

@synthesize throttleIndicator, yawIndicator, pitchIndicator, rollIndicator;
@synthesize flightController;

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

- (void)flightControllerDidReceiveThrottle:(NSInteger)throttle yaw:(NSInteger)yaw pitch:(NSInteger)pitch roll:(NSInteger)roll {
    [throttleIndicator setIntegerValue:throttle];
    [yawIndicator setIntegerValue:yaw];
    [pitchIndicator setIntegerValue:pitch];
    [rollIndicator setIntegerValue:roll];
}

@end
