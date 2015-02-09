//
//  ChannelConfig.m
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "ChannelConfig.h"

@implementation ChannelConfig

@synthesize minValue;
@synthesize maxValue;
@synthesize reversed;
@synthesize channel;

- (id)init {
    if( self = [super init] ) { }
    return self;
}

- (id)initForChannel:(int)aChannel withMin:(NSInteger)aMinValue andMax:(NSInteger)aMaxValue {
    if( self = [super init] ) {
        self.channel = aChannel;
        self.minValue = aMinValue;
        self.maxValue = aMaxValue;
        self.reversed = NO;
    }
    return self;
}

- (NSInteger)valueForChannel:(int)aChannel fromPacket:(RxPacket)packet {
    // TODO: this is really pretty crap. Some refactoring is inorder.
    NSArray *channels = @[
                          [NSNumber numberWithInteger:packet.channel1],
                          [NSNumber numberWithInteger:packet.channel2],
                          [NSNumber numberWithInteger:packet.channel3],
                          [NSNumber numberWithInteger:packet.channel4],
                          [NSNumber numberWithInteger:packet.channel5],
                          [NSNumber numberWithInteger:packet.channel6]
                          ];
                          
    return [((NSNumber *)channels[aChannel-1]) integerValue];
}

- (NSInteger)valueFromPacket:(RxPacket)packet {
    NSInteger rawValue = [self valueForChannel:channel fromPacket:packet];
    return [self convertRawValue:rawValue];
}

- (NSInteger)convertRawValue:(NSInteger)rawValue {
    if( rawValue <= minValue )
    {
        return reversed ? 1000 : 0;
    }
    else if( rawValue >= maxValue )
    {
        return reversed ? 0 : 1000;
    }
    else
    {
        float scale = (float)(maxValue - minValue) / 1000;
        int scaledValue = (int)((rawValue - minValue) / scale);
        return reversed ? (scaledValue - 1000) * -1 : scaledValue;
    }
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"Min: %lu, Max: %lu, Channel: %d", minValue, maxValue, channel];
}


@end
