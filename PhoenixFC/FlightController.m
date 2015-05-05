//
//  FlightController.m
//  FlightControl
//
//  Created by Colin Harris on 1/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "FlightController.h"
#import "ORSSerialRequest.h"
#import "NSData+PhoenixFC.h"

#define NO_VALUE -123456789

@interface FlightController ()

@property (strong) NSMutableString *inputBuffer;

@end

@implementation FlightController

@synthesize serialPort, consoleOutput, delegate;

- (id)init {
    if( self = [super init] ) {
        
        self.consoleOutput = [[NSMutableString alloc] init];
        
        self.serialPort = [ORSSerialPort serialPortWithPath:@"/dev/tty.usbmodem1412"];
        serialPort.delegate = self;
        serialPort.baudRate = @9600;
        
        self.inputBuffer = [[NSMutableString alloc] init];
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

- (void)sendRxRequest {
    NSData *requestData = [@"RX" dataUsingEncoding:NSASCIIStringEncoding];
    ORSSerialRequest *request = [ORSSerialRequest
                                  requestWithDataToSend:requestData
                                               userInfo:@"RX"
                                        timeoutInterval:0.1
                                      responseEvaluator:^BOOL(NSData *inputData) {
                                          if ([inputData length] != 54) return NO;
                                          NSData *headerData = [inputData subdataWithRange:NSMakeRange(0, 4)];
                                          NSString *header = [[NSString alloc] initWithData:headerData encoding:NSASCIIStringEncoding];
                                          return [header isEqualToString:@"CH1:"];
                                      }];
    [serialPort sendRequest:request];
}


- (void)sendSensorRequest {
    NSData *requestData = [@"SA" dataUsingEncoding:NSASCIIStringEncoding];
    ORSSerialRequest *request = [ORSSerialRequest
                                  requestWithDataToSend:requestData
                                               userInfo:@"SA"
                                        timeoutInterval:0.1
                                      responseEvaluator:^BOOL(NSData *inputData) {
                                          if ([inputData length] < 47) return NO;
                                          NSData *headerData = [inputData subdataWithRange:NSMakeRange(0, 3)];
                                          NSString *header = [[NSString alloc] initWithData:headerData encoding:NSASCIIStringEncoding];
                                          return [header isEqualToString:@"AX:"];
                                      }];
    [serialPort sendRequest:request];
}

- (void)sendRawRxRequest {
    NSData *requestData = [@"RR" dataUsingEncoding:NSASCIIStringEncoding];
    ORSSerialRequest *request = [ORSSerialRequest
                                 requestWithDataToSend:requestData
                                 userInfo:@"RR"
                                 timeoutInterval:0.1
                                 responseEvaluator:^BOOL(NSData *inputData) {
                                     if ([inputData length] != 54) return NO;
                                     NSData *headerData = [inputData subdataWithRange:NSMakeRange(0, 4)];
                                     NSString *header = [[NSString alloc] initWithData:headerData encoding:NSASCIIStringEncoding];
                                     return [header isEqualToString:@"CH1:"];
                                 }];
    [serialPort sendRequest:request];
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveResponse:(NSData *)responseData toRequest:(ORSSerialRequest *)request {
    NSString *requestId = [request userInfo];
    if( [requestId isEqualToString:@"RX"] )
    {
        RxPacket packet = [self processRxPacket:responseData];
        if( [delegate respondsToSelector:@selector(flightControllerDidReceiveRxPacket:)] )
            [delegate flightControllerDidReceiveRxPacket:packet];
    }
    else if( [requestId isEqualToString:@"RR"] )
    {
        RxPacket packet = [self processRxPacket:responseData];
        if( [delegate respondsToSelector:@selector(flightControllerDidReceiveRawRxPacket:)] )
            [delegate flightControllerDidReceiveRawRxPacket:packet];
    }
    else if( [requestId isEqualToString:@"SA"] )
    {
        SensorPacket packet = [self processSensorPacket:responseData];
        if( [delegate respondsToSelector:@selector(flightControllerDidReceiveSensorPacket:)] )
            [delegate flightControllerDidReceiveSensorPacket:packet];
    }
}

- (void)serialPort:(ORSSerialPort *)serialPort requestDidTimeout:(ORSSerialRequest *)request {
    NSLog(@"timeout");
}

// Packet Format
// CH1:1000,CH2:1000,CH3:1000,CH4:1000,CH5:1000,CH6:1000;
- (RxPacket)processRxPacket:(NSData *)data {
    RxPacket packet;
    packet.channel1 = [data getIntegerWithRange:NSMakeRange(4,4)];
    packet.channel2 = [data getIntegerWithRange:NSMakeRange(13,4)];
    packet.channel3 = [data getIntegerWithRange:NSMakeRange(22,4)];
    packet.channel4 = [data getIntegerWithRange:NSMakeRange(31,4)];
    packet.channel5 = [data getIntegerWithRange:NSMakeRange(40,4)];
    packet.channel6 = [data getIntegerWithRange:NSMakeRange(49,4)];
    return packet;
}

// Packet Format
// AX:1000,AY:1000,AZ:1000,GX:1000,GY:1000,GZ:1000;
- (SensorPacket)processSensorPacket:(NSData *)data {
    NSString *sensorData = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray *components = [sensorData componentsSeparatedByString:@","];

    SensorPacket packet;
    packet.accel_x = [[components[0] substringFromIndex:3] intValue] / 20;
//    packet.accel_y = [data getIntegerWithRange:NSMakeRange(11,4)];
//    packet.accel_z = [data getIntegerWithRange:NSMakeRange(19,4)];
//    packet.gyro_x = [data getIntegerWithRange:NSMakeRange(27,4)];
//    packet.gyro_y = [data getIntegerWithRange:NSMakeRange(35,4)];
//    packet.gyro_z = [data getIntegerWithRange:NSMakeRange(43,4)];

    return packet;
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
