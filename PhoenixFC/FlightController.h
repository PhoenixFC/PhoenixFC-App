//
//  FlightController.h
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORSSerialPort.h"

typedef struct _RxPacket
{
    NSInteger channel1;
    NSInteger channel2;
    NSInteger channel3;
    NSInteger channel4;
    NSInteger channel5;
    NSInteger channel6;
} RxPacket;

@protocol FlightControllerDelegate
@optional
- (void)flightControllerConsoleDidChange:(NSString *)value;
- (void)flightControllerDidReceiveRxPacket:(RxPacket)packet;
- (void)flightControllerDidReceiveRawRxPacket:(RxPacket)packet;
@end

@interface FlightController : NSObject <ORSSerialPortDelegate>

@property (strong) ORSSerialPort *serialPort;
@property (strong) NSMutableString *consoleOutput;
@property (weak) NSObject<FlightControllerDelegate> *delegate;

- (void)connect;
- (void)disconnect;
- (BOOL)isConnected;

- (void)sendRxRequest;
- (void)sendRawRxRequest;

@end
