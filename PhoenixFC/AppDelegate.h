//
//  AppDelegate.h
//  FlightControl
//
//  Created by Colin Harris on 23/1/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) FlightController *flightController;

@end

