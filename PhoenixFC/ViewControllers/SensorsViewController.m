//
//  SensorsViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "SensorsViewController.h"
#import "AppDelegate.h"

@interface SensorsViewController ()

@property (nonatomic, assign) SensorPacket sensorPacket;
@property (strong) NSTimer *timer;

@end

@implementation SensorsViewController

@synthesize sensorGraph, fakeDataSlider, flightController;


- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    self.flightController = appDelegate.flightController;

    [self startTimer];
    self.sensorGraph.dataSource = self;
}

- (void)viewDidAppear {
    [super viewDidAppear];

    flightController.delegate = self;
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self stopTimer];
}

- (NSNumber *)currentValue {
    return @(_sensorPacket.accel_x);
}

- (void)startTimer {
    if( self.timer == nil ) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1/50 target:flightController selector:@selector(sendSensorRequest) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)flightControllerDidReceiveSensorPacket:(SensorPacket)packet {
    self.sensorPacket = packet;
}

@end
