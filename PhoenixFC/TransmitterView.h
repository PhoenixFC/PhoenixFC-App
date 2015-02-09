//
//  TransmitterView.h
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TransmitterStickView.h"

@interface TransmitterView : NSView

@property (retain) NSImageView *imageView;
@property (retain) TransmitterStickView *leftStick;
@property (retain) TransmitterStickView *rightStick;

- (void)animateThrottle;
- (void)animateYaw;
- (void)animatePitch;
- (void)animateRoll;

- (void)removeAnimations;

- (void)updateThrottle:(NSInteger)throttle yaw:(NSInteger)yaw pitch:(NSInteger)pitch roll:(NSInteger)roll;

@end
