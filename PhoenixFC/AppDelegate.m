//
//  AppDelegate.m
//  FlightControl
//
//  Created by Colin Harris on 23/1/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize flightController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (FlightController *)flightController {
    if( flightController == nil ) {
        self.flightController = [[FlightController alloc] init];
    }
    return flightController;
}

@end
