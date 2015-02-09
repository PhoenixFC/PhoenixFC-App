//
//  RxConfigWizardViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RxConfigWizardViewController.h"
#import "AppDelegate.h"
#import "RxWizardStep.h"
#import "ChannelConfig.h"

@interface RxConfigWizardViewController ()
@property (strong) NSTimer *rxUpdateTimer;
@property (strong) NSArray *steps;
@property (assign) RxWizardStep *currentStep;

@property (strong) ChannelConfig *throttleConfig;
@property (strong) ChannelConfig *yawConfig;
@property (strong) ChannelConfig *pitchConfig;
@property (strong) ChannelConfig *rollConfig;
@end

@implementation RxConfigWizardViewController{
    
    NSInteger minValues[6];
    NSInteger maxValues[6];
    NSInteger ranges[6];
    
}

@synthesize flightController;
@synthesize label, transmitterView;
@synthesize rxUpdateTimer;
@synthesize steps, currentStep;
@synthesize throttleConfig, yawConfig, pitchConfig, rollConfig;
@synthesize throttleReverse, yawReverse, pitchReverse, rollReverse;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.throttleConfig = [[ChannelConfig alloc] init];
    self.yawConfig = [[ChannelConfig alloc] init];
    self.pitchConfig = [[ChannelConfig alloc] init];
    self.rollConfig = [[ChannelConfig alloc] init];
    
    self.steps = @[
              [[RxWizardStep alloc] initWithLabel:@"Step 1: Move your throttle up and down to it's limits."
                                        imageName:@"Radio_Throttle"
                                      andSelector:@selector(animateThrottle)],
              
              [[RxWizardStep alloc] initWithLabel:@"Step 2: Move your yaw left and right to it's limits."
                                        imageName:@"Radio_Yaw"
                                      andSelector:@selector(animateYaw)],
              
              [[RxWizardStep alloc] initWithLabel:@"Step 3: Move your pitch up and down to its limits."
                                        imageName:@"Radio_Pitch"
                                      andSelector:@selector(animatePitch)],
              
              [[RxWizardStep alloc] initWithLabel:@"Step 4: Move your roll left and right to its limits."
                                        imageName:@"Radio_Roll"
                                      andSelector:@selector(animateRoll)],
              
              [[RxWizardStep alloc] initWithLabel:@"Step 5: Confirm all controls move as expected."
                                        imageName:@"Radio_Blank"
                                      andSelector:@selector(removeAnimations)]
              ];
    
    [self reset];
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    self.flightController = appDelegate.flightController;
}

- (void)moveToNextStep {
    if( currentStep != [steps lastObject] ) {
        NSUInteger index = [steps indexOfObject:currentStep];
        currentStep = index == NSNotFound ? [steps firstObject] : [steps objectAtIndex:index+1];
        
        label.stringValue = currentStep.label;
        transmitterView.imageView.image = [NSImage imageNamed:currentStep.transmitterImageName];
        if( [transmitterView respondsToSelector:currentStep.animationSelector] )
            [transmitterView performSelector:currentStep.animationSelector];
    } else {
        // Finished!
        // TODO: WTF do I do now ?!?
        NSLog(@"Throttle: %@", [throttleConfig toString]);
        NSLog(@"Yaw: %@", [yawConfig toString]);
        NSLog(@"Pitch: %@", [pitchConfig toString]);
        NSLog(@"Roll: %@", [rollConfig toString]);
    }
}

- (void)moveToPrevStep {
    if( currentStep != [steps firstObject] ) {
        NSUInteger index = [steps indexOfObject:currentStep];
        currentStep = index == NSNotFound ? [steps lastObject] : [steps objectAtIndex:index-1];
        
        label.stringValue = currentStep.label;
        transmitterView.imageView.image = [NSImage imageNamed:currentStep.transmitterImageName];
        if( [transmitterView respondsToSelector:currentStep.animationSelector] )
            [transmitterView performSelector:currentStep.animationSelector];
    } else {
        // Finished!
        // TODO: WTF do I do now ?!?
        NSLog(@"Throttle: %@", [throttleConfig toString]);
        NSLog(@"Yaw: %@", [yawConfig toString]);
        NSLog(@"Pitch: %@", [pitchConfig toString]);
        NSLog(@"Roll: %@", [rollConfig toString]);
        
        [self dismissViewController:self];
    }
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    flightController.delegate = self;
    [flightController connect];
    
    [self startTimer];
    
    [self moveToNextStep];
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

- (ChannelConfig *)channelConfigForStep {
    NSUInteger index = [steps indexOfObject:currentStep];
    if( index == 0 ) {
        return throttleConfig;
    }
    else if( index == 1 ) {
        return yawConfig;
    }
    else if( index == 2 ) {
        return pitchConfig;
    }
    else if( index == 3 ) {
        return rollConfig;
    }
    return nil;
}

- (IBAction)nextClicked:(id)sender {
    NSLog(@"nextClicked");

    ChannelConfig *channelConfig = [self channelConfigForStep];
    if( channelConfig ) {
        [self updateChannelRanges];
        int channel = [self channelWithMaxRange];
        channelConfig.channel = channel;
        channelConfig.minValue = minValues[channel-1];
        channelConfig.maxValue = maxValues[channel-1];
        NSLog(@"Channel %d - Min: %lu  Max: %lu", channel, minValues[channel-1], maxValues[channel-1]);
    }
    
    [self reset];
    [self moveToNextStep];
}

- (IBAction)prevClicked:(id)sender {
    NSLog(@"prevClicked");
    [self reset];
    [self moveToPrevStep];
}

- (void)flightControllerDidReceiveRawRxPacket:(RxPacket)packet {
    if( currentStep != [steps lastObject] ) {
        [self updateMinChannelValues:packet];
        [self updateMaxChannelValues:packet];
    } else {
        NSInteger throttle = [throttleConfig valueFromPacket:packet];
        NSInteger yaw = [yawConfig valueFromPacket:packet];
        NSInteger pitch = [pitchConfig valueFromPacket:packet];
        NSInteger roll = [rollConfig valueFromPacket:packet];
        NSLog(@"Update Tx - THR: %lu, YAW: %lu, PIT: %lu ROL: %lu", throttle, yaw, pitch, roll);
        [transmitterView updateThrottle:throttle yaw:yaw pitch:pitch roll:roll];
    }
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

- (IBAction)throttleReverseClicked:(id)sender {
    NSButton *button = (NSButton *)sender;
    throttleConfig.reversed = button.state == NSOnState;
}

- (IBAction)yawReverseClicked:(id)sender {
    NSButton *button = (NSButton *)sender;
    yawConfig.reversed = button.state == NSOnState;
}

- (IBAction)pitchReverseClicked:(id)sender {
    NSButton *button = (NSButton *)sender;
    pitchConfig.reversed = button.state == NSOnState;
}

- (IBAction)rollReverseClicked:(id)sender {
    NSButton *button = (NSButton *)sender;
    rollConfig.reversed = button.state == NSOnState;
}

@end
