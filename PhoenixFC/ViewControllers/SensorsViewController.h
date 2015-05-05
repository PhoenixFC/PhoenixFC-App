//
//  SensorsViewController.h
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SensorGraphView.h"
#import "FlightController.h"

@interface SensorsViewController : NSViewController <SensorGraphDataSource, FlightControllerDelegate>

@property (nonatomic, weak) IBOutlet SensorGraphView *sensorGraph;
@property (nonatomic, weak) IBOutlet NSSlider *fakeDataSlider;

@property (nonatomic, strong) FlightController *flightController;
@end
