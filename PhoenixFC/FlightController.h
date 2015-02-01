//
//  FlightController.h
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSSerialPort.h"

@protocol FlightControllerDelegate
@optional
- (void)flightControllerDidReceiveThrottle:(NSInteger)throttle yaw:(NSInteger)yaw pitch:(NSInteger)pitch roll:(NSInteger)roll;
- (void)flightControllerConsoleDidChange:(NSString *)value;
@end

@interface FlightController : NSObject <ORSSerialPortDelegate>

@property (strong) ORSSerialPort *serialPort;
@property (strong) NSMutableString *consoleOutput;
@property (weak) NSObject<FlightControllerDelegate> *delegate;

- (void)connect;
- (void)disconnect;
- (BOOL)isConnected;

@end
