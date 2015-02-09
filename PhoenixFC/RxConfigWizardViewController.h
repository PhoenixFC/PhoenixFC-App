//
//  RxConfigWizardViewController.h
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlightController.h"
#import "TransmitterView.h"

@interface RxConfigWizardViewController : NSViewController <FlightControllerDelegate>

@property (weak) FlightController *flightController;

@property (assign) IBOutlet NSTextField *label;
@property (assign) IBOutlet TransmitterView *transmitterView;

@property (assign) IBOutlet NSButton *throttleReverse;
@property (assign) IBOutlet NSButton *yawReverse;
@property (assign) IBOutlet NSButton *pitchReverse;
@property (assign) IBOutlet NSButton *rollReverse;

- (IBAction)nextClicked:(id)sender;
- (IBAction)prevClicked:(id)sender;

- (IBAction)throttleReverseClicked:(id)sender;
- (IBAction)yawReverseClicked:(id)sender;
- (IBAction)pitchReverseClicked:(id)sender;
- (IBAction)rollReverseClicked:(id)sender;

@end
