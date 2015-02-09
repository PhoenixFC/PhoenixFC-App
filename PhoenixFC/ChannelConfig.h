//
//  ChannelConfig.h
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightController.h"

@interface ChannelConfig : NSObject

@property (assign) NSInteger minValue;
@property (assign) NSInteger maxValue;
@property (assign) BOOL reversed;
@property (assign) int channel;

- (id)init;
- (id)initForChannel:(int)aChannel withMin:(NSInteger)aMinValue andMax:(NSInteger)aMaxValue;

- (NSInteger)convertRawValue:(NSInteger)rawValue;
- (NSInteger)valueFromPacket:(RxPacket)packet;

- (NSString *)toString;

@end
