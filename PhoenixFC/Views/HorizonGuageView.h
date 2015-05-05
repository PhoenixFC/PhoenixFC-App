//
//  HorizonGuageView.h
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol HorizonGuageDataSource <NSObject>
-(NSNumber *)currentPitchAngle;
-(NSNumber *)currentRollAngle;
@end

@interface HorizonGuageView : NSView

@property (nonatomic, weak) id<HorizonGuageDataSource> dataSource;

@end
