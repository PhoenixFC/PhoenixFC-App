//
//  FlightController.m
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "FlightController.h"

#define NO_VALUE -123456789

@implementation FlightController

@synthesize serialPort, consoleOutput, delegate;

- (id)init {
    if( self = [super init] ) {
        
        self.consoleOutput = [[NSMutableString alloc] init];
        
        self.serialPort = [ORSSerialPort serialPortWithPath:@"/dev/tty.usbmodem1412"];
        serialPort.delegate = self;
        serialPort.baudRate = @9600;
        
    }
    return self;
}

- (void)connect {
    if( !serialPort.isOpen ) {
        [consoleOutput setString:@""];
        [self appendText:@"Connecting...\n"];
        [serialPort open];
    }
}

- (void)disconnect {
    if( serialPort.isOpen )
        [serialPort close];
}

- (BOOL)isConnected {
    return serialPort.isOpen;
}

- (void)sendData:(NSData *)data {
    [self.serialPort sendData:data];
}

- (void)sendString:(NSString *)string {
    [self.serialPort sendData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data {
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [self appendText:value];

    if( [value hasPrefix:@"Throttle:"] ) {
        NSInteger throttle = [self valueForChannel:@"Throttle:" inString:value];
        NSInteger yaw = [self valueForChannel:@"Yaw:" inString:value];
        NSInteger pitch = [self valueForChannel:@"Pitch:" inString:value];
        NSInteger roll = [self valueForChannel:@"Roll:" inString:value];
        
        if( throttle != NO_VALUE && [delegate respondsToSelector:@selector(flightControllerDidReceiveThrottle:yaw:pitch:roll:)] ) {
            [delegate flightControllerDidReceiveThrottle:throttle yaw:yaw pitch:pitch roll:roll];
        }
    }
}

- (NSInteger)valueForChannel:(NSString *)channelName inString:(NSString *)value {
    NSRange range = [value rangeOfString:channelName];
    if( range.location != NSNotFound ) {
        NSRange valueRange = NSMakeRange(range.location+[channelName length], 4);
        return [[value substringWithRange:valueRange] intValue];
    }
    return NO_VALUE;
}

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort {
    [self appendText:@"Disconnected!\n"];
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort {
    [self appendText:@"Closed!\n"];
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort {
    [self appendText:@"Connected!\n"];
}

- (void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error {
    [self appendText:@"Error!\n"];
}

-( void)appendText:(NSString *)text {
    if( [delegate respondsToSelector:@selector(flightControllerConsoleDidChange:)] )
        [delegate flightControllerConsoleDidChange:text];
    [consoleOutput appendString:[NSString stringWithFormat:@"%@",text]];
}


@end
