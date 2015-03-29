//
//  ChannelConfig.h
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightController.h"
#import "ChannelType.h"

@interface ChannelConfig : NSObject

@property (assign) ChannelType type;
@property (assign) NSInteger minValue;
@property (assign) NSInteger maxValue;
@property (assign) BOOL reversed;
@property (assign) int channel;

- (id)init;

- (NSInteger)convertRawValue:(NSInteger)rawValue;

- (NSInteger)valueFromPacket:(RxPacket)packet;

- (NSString *)toString;

@end
