//
//  RxConfigWizardViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "RxConfigWizardViewController.h"
#import "AppDelegate.h"

@interface RxConfigWizardViewController ()
@property (strong) NSTimer *rxUpdateTimer;
@end

@implementation RxConfigWizardViewController{
    
    NSInteger minValues[6];
    NSInteger maxValues[6];
    NSInteger ranges[6];
    
}

@synthesize flightController;
@synthesize rxUpdateTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reset];
    
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
        self.rxUpdateTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.1 target:self selector:@selector(sendRawRxRequest) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.rxUpdateTimer forMode:NSModalPanelRunLoopMode];
    }
}

- (void)sendRawRxRequest {
    [flightController sendRawRxRequest];
}

- (void)stopTimer {
    [self.rxUpdateTimer invalidate];
    self.rxUpdateTimer = nil;
}

- (IBAction)nextClicked:(id)sender {
    NSLog(@"nextClicked");
    [self updateChannelRanges];
    
    int channel = [self channelWithMaxRange];
    NSLog(@"Channel %d - Min: %lu  Max: %lu", channel, minValues[channel-1], maxValues[channel-1]);
    
    [self reset];
}

- (void)flightControllerDidReceiveRawRxPacket:(RxPacket)packet {
    [self updateMinChannelValues:packet];
    [self updateMaxChannelValues:packet];
}

- (void)reset {
    for(int i=0; i<6; i++) {
        minValues[i] = -1;
        maxValues[i] = -1;
        ranges[i] = -1;
    }
}

- (void)setMinValue:(NSInteger)value forChannel:(int)channel {
    int channelIndex = channel -1;
    if( minValues[channelIndex] == -1 || value < minValues[channelIndex] )
        minValues[channelIndex] = value;
}

- (void)setMaxValue:(NSInteger)value forChannel:(int)channel {
    int channelIndex = channel -1;
    if( maxValues[channelIndex] == -1 || value > maxValues[channelIndex] )
        maxValues[channelIndex] = value;
}

- (void)updateMinChannelValues:(RxPacket)packet {
    [self setMinValue:packet.channel1 forChannel:1];
    [self setMinValue:packet.channel2 forChannel:2];
    [self setMinValue:packet.channel3 forChannel:3];
    [self setMinValue:packet.channel4 forChannel:4];
    [self setMinValue:packet.channel5 forChannel:5];
    [self setMinValue:packet.channel6 forChannel:6];
}

- (void)updateMaxChannelValues:(RxPacket)packet {
    [self setMaxValue:packet.channel1 forChannel:1];
    [self setMaxValue:packet.channel2 forChannel:2];
    [self setMaxValue:packet.channel3 forChannel:3];
    [self setMaxValue:packet.channel4 forChannel:4];
    [self setMaxValue:packet.channel5 forChannel:5];
    [self setMaxValue:packet.channel6 forChannel:6];
}

- (void)updateChannelRanges {
    for(int i=0; i<6; i++) {
        ranges[i] = maxValues[i] - minValues[i];
    }
}

- (int)channelWithMaxRange {
    NSInteger maxRange = 0;
    int channel = 0;
    for(int i=0; i<6; i++) {
        if( ranges[i] > maxRange ) {
            maxRange = ranges[i];
            channel = i+1;
        }
    }
    return channel;
}

-(IBAction)close:(id)sender {
    NSLog(@"Closing the Rx Wizard!");
}

@end
