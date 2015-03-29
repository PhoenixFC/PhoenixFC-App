//
//  SensorsViewController.h
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SensorGraphView.h"

@interface SensorsViewController : NSViewController <SensorGraphDataSource>

@property (nonatomic, weak) IBOutlet SensorGraphView *sensorGraph;
@property (nonatomic, weak) IBOutlet NSSlider *fakeDataSlider;

@end
