//
//  GuagesViewController.h
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"

@class HorizonGuageView;

@interface GuagesViewController : NSViewController <HorizonGuageDataSource, FlightControllerDelegate>

@property  (nonatomic, weak) IBOutlet NSSlider *pitchSlider;
@property  (nonatomic, weak) IBOutlet NSSlider *rollSlider;

@property  (nonatomic, weak) IBOutlet HorizonGuageView *horizonGuage;

@property  (nonatomic, weak) FlightController *flightController;

@end
