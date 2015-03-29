//
//  ViewController.h
//  FlightControl
//
//  Created by Colin Harris on 23/1/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"

@interface ConsoleViewController : NSViewController <FlightControllerDelegate>

@property (assign) IBOutlet NSTextView *textView;

@property (weak) FlightController *flightController;

@end

