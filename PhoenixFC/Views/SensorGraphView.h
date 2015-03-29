//
//  SensorGraphView.h
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SensorGraphDataSource <NSObject>
- (NSNumber *)currentValue;
@end

@interface SensorGraphView : NSView

@property (nonatomic, weak) id<SensorGraphDataSource> dataSource;

@end
