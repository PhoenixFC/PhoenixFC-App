//
//  GuagesViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "HorizonGuageView.h"
#import "GuagesViewController.h"
#import "HorizonGuageView.h"

@interface GuagesViewController ()

@end

@implementation GuagesViewController

@synthesize pitchSlider, rollSlider, horizonGuage;

- (void)viewDidLoad {
    [super viewDidLoad];

    horizonGuage.dataSource = self;
}

- (NSNumber *)currentPitchAngle {
    return @([pitchSlider floatValue]);
}

- (NSNumber *)currentRollAngle {
    return @([rollSlider floatValue]);
}

@end
