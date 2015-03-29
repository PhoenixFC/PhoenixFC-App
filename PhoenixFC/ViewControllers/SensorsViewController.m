//
//  SensorsViewController.m
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "SensorsViewController.h"

@interface SensorsViewController ()

@end

@implementation SensorsViewController

@synthesize sensorGraph, fakeDataSlider;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorGraph.dataSource = self;
}

- (NSNumber *)currentValue {
    return @([fakeDataSlider floatValue]);
}

@end
