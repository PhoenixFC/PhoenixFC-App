//
//  HorizonGuageView.m
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "HorizonGuageView.h"
#import "NSImage+Transform.h"

@interface HorizonGuageView ()
@property (nonatomic, strong) NSImage *foregroundImage;
@property (nonatomic, strong) NSImage *backgroundImage;

@property (nonatomic, strong) NSNumber *pitch;
@property (nonatomic, strong) NSNumber *roll;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HorizonGuageView

@synthesize foregroundImage, backgroundImage, dataSource, timer, pitch, roll;

- (id)initWithCoder:(NSCoder *)coder {
    if( self = [super initWithCoder:coder] ) {
        self.backgroundImage = [NSImage imageNamed:@"HorizonGuageBackground"];
        self.foregroundImage = [NSImage imageNamed:@"HorizonGuageForeground"];
        self.wantsLayer = YES;
        [self startTimer];
    }
    return self;
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/20 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSEventTrackingRunLoopMode];
}

- (void)tick {
    self.pitch = [dataSource currentPitchAngle];
    self.roll = [dataSource currentRollAngle];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

//    NSPoint centerPoint = NSMakePoint(self.frame.size.width / 2, self.frame.size.height / 2);
//    NSAffineTransform *transform = [NSAffineTransform transform];
//    [transform translateXBy:centerPoint.x yBy:centerPoint.y];
//    [transform rotateByDegrees:45.0];
//    [transform translateXBy:-centerPoint.x yBy:-centerPoint.y];
//    [transform concat];

//    [self setFrameOrigin:NSMakePoint(100,100)];
//    self.layer.affineTransform = CGAffineTransformMakeRotation(45);

    NSImage *image = [backgroundImage imageRotatedByDegrees:[roll floatValue]];
    [image drawInRect:CGRectMake(0, 0, 200, 200)];

    [foregroundImage drawInRect:CGRectMake(0, 0, 200, 200)];

}

@end
