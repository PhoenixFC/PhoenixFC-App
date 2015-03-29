//
//  TransmitterConfigViewController.h
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"

@interface TransmitterConfigViewController : NSViewController <FlightControllerDelegate>

@property (assign) IBOutlet NSLevelIndicator *throttleIndicator;
@property (assign) IBOutlet NSLevelIndicator *yawIndicator;
@property (assign) IBOutlet NSLevelIndicator *pitchIndicator;
@property (assign) IBOutlet NSLevelIndicator *rollIndicator;

@property (weak) FlightController *flightController;


@end
