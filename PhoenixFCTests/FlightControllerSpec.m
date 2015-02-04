//
//  FlightControlSpec.m
//  FlightControlSpec
//
//  Created by Colin Harris on 23/1/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OCMock/OCMock.h>
#import "Specta.h"
#import "FlightController.h"
#import "ORSSerialPort.h"


SpecBegin(FlightController)

describe(@"FlightController", ^{
    
    __block FlightController *flightController;
    __block id serialPort;
    
    beforeEach(^{
        serialPort = OCMStrictClassMock([ORSSerialPort class]);
        OCMStub([serialPort serialPortWithPath:[OCMArg any]]).andReturn(serialPort);
        OCMExpect([serialPort setDelegate:[OCMArg any]]);
        OCMExpect([serialPort setBaudRate:[OCMArg any]]);
        flightController = [[FlightController alloc] init];
    });
    
    describe(@"connect", ^{
        
        describe(@"when the serial port isn't connected", ^{
           
            beforeEach(^{
                OCMStub([serialPort isOpen]).andReturn(NO);
            });
            
            it(@"opens the serial port", ^{
                OCMExpect([serialPort open]);
                [flightController connect];
                OCMVerifyAll(serialPort);
            });
            
        });
        
        describe(@"when the serial port is already connected", ^{
            
            beforeEach(^{
                OCMStub([serialPort isOpen]).andReturn(YES);
            });
            
            it(@"does not open the serial port", ^{
                [flightController connect];
                OCMVerifyAll(serialPort);
            });
            
        });
        
    });
    
    describe(@"disconnect", ^{
        
        describe(@"when the serial port is connected", ^{
            
            beforeEach(^{
                OCMStub([serialPort isOpen]).andReturn(YES);
            });
            
            it(@"closes the serial port", ^{
                OCMExpect([(ORSSerialPort *)serialPort close]);
                [flightController disconnect];
                OCMVerifyAll(serialPort);
            });
            
        });
        
        describe(@"when the serial port is not connected", ^{
            
            beforeEach(^{
                OCMStub([serialPort isOpen]).andReturn(NO);
            });
            
            it(@"does not close the serial port", ^{
                [flightController disconnect];
                OCMVerifyAll(serialPort);
            });
            
        });
        
    });
    
});

SpecEnd