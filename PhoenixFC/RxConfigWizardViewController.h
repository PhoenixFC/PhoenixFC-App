//
//  RxConfigWizardViewController.h
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"

@interface RxConfigWizardViewController : NSViewController <FlightControllerDelegate>

@property (weak) FlightController *flightController;

@property (assign) IBOutlet NSImageView *imageView;
@property (assign) IBOutlet NSTextField *label;

- (IBAction)nextClicked:(id)sender;

@end
