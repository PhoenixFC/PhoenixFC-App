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
@property (strong) NSTimer *rxUpdateTimer;
@end

@implementation TransmitterConfigViewController

@synthesize throttleIndicator, yawIndicator, pitchIndicator, rollIndicator;
@synthesize flightController;
@synthesize rxUpdateTimer;

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    self.flightController = appDelegate.flightController;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    flightController.delegate = self;
    [flightController connect];
    
    [self startTimer];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self stopTimer];
}

- (void)startTimer {
    if( self.rxUpdateTimer == nil ) {
        self.rxUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:flightController selector:@selector(sendRxRequest) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    [self.rxUpdateTimer invalidate];
    self.rxUpdateTimer = nil;
}

- (void)flightControllerDidReceiveRxPacket:(RxPacket)packet {
    NSLog(@"CH1%4ld,CH2%4ld,CH3%4ld,CH4%4ld,CH5%4ld,CH6%4ld;",
          (long)packet.channel1,
          (long)packet.channel2,
          (long)packet.channel3,
          (long)packet.channel4,
          (long)packet.channel5,
          (long)packet.channel6
          );
    
    [throttleIndicator setIntegerValue:packet.channel1];
    [yawIndicator setIntegerValue:packet.channel2];
    [pitchIndicator setIntegerValue:packet.channel3];
    [rollIndicator setIntegerValue:packet.channel4];
}

@end
