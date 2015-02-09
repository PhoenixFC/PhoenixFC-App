//
//  RxConfigWizardViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "RxConfigWizardViewController.h"
#import "AppDelegate.h"
#import "BlueDotView.h"
#import <QuartzCore/QuartzCore.h>

@interface RxConfigWizardViewController ()
@property (strong) NSTimer *rxUpdateTimer;
@end

@implementation RxConfigWizardViewController{
    
    NSInteger minValues[6];
    NSInteger maxValues[6];
    NSInteger ranges[6];
    
    NSArray *stepLabels;
    NSArray *stepImages;
    int currentStep;
    
    BlueDotView *dot;
    
}

@synthesize flightController;
@synthesize rxUpdateTimer;
@synthesize imageView;
@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    stepLabels = @[
              @"Step 1: Move your throttle up and down to it's limits.",
              @"Step 2: Move your yaw left and right to it's limits.",
              @"Step 3: Move your pitch up and down to its limits.",
              @"Step 4: Move your roll left and right to its limits."
              ];
    stepImages = @[
                @"Radio_Throttle",
                @"Radio_Yaw",
                @"Radio_Pitch",
                @"Radio_Roll",
                ];
    
    [self reset];
    
    currentStep = 0;
    [self moveToStep:currentStep];
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    self.flightController = appDelegate.flightController;
}

- (void)moveToStep:(int)step {
    self.label.stringValue = [stepLabels objectAtIndex:currentStep];
    self.imageView.image = [NSImage imageNamed:[stepImages objectAtIndex:currentStep]];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    flightController.delegate = self;
    [flightController connect];
    
//    [self addDot];
    
//    [self startTimer];
    
//    self.imageView.hidden = YES;
    
    
    CALayer* layer = [CALayer layer];
    [layer setFrame:CGRectMake(65, 110, 20, 20)];
    [self.imageView.layer addSublayer:layer];
    
    [layer setDelegate:self];
    [layer setNeedsDisplay];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:1.5];
    [animation setRepeatCount:INT_MAX];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithPoint:CGPointMake(69, 90)]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake(69, 150)]];
    [layer addAnimation:animation forKey:nil];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    CGRect borderRect = CGRectMake(3, 3, 14, 14);
    CGContextSetStrokeColorWithColor(ctx, [NSColor blueColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [NSColor blueColor].CGColor);
    CGContextFillEllipseInRect(ctx, borderRect);
    CGContextFillPath(ctx);
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
    currentStep += 1;
    [self moveToStep:currentStep];
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
