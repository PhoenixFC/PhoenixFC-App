//
//  SensorGraphView.m
//  PhoenixFC
//
//  Created by Colin Harris on 29/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Specta/SpectaDSL.h>
#import "SensorGraphView.h"

#define kVerticalCells 36
#define kFPS 50

@interface SensorGraphView ()
@property (nonatomic, assign) NSUInteger frameCount;
@property (nonatomic, strong) NSTimer *frameTimer;
@property (nonatomic, strong) NSMutableArray *dataBuffer;
@end

@implementation SensorGraphView

@synthesize frameCount, frameTimer, dataBuffer, dataSource;

- (id)initWithCoder:(NSCoder *)coder {
    if( self = [super initWithCoder:coder] ) {
        self.frameCount = 0;
        self.frameTimer = [NSTimer scheduledTimerWithTimeInterval:1/kFPS target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:frameTimer forMode:NSEventTrackingRunLoopMode];

        self.dataBuffer = [[NSMutableArray alloc] initWithCapacity:500];
        for(int i=0; i<500; i++) {
            [dataBuffer addObject:@0.0];
        }
    }
    return self;
}

- (void)tick {
    frameCount += 1;

    [dataBuffer removeObjectAtIndex:0];
    [dataBuffer addObject:[dataSource currentValue]];
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    [self drawGridLines:context];
    [self drawQuarterLines:context];

    [self drawData:context];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)cellSize {
    return self.height / kVerticalCells;
}

- (CGFloat)unitSize {
    return self.cellSize / 10;
}

- (CGFloat)stepSize {
    return self.cellSize / kFPS;
}

- (void)drawData:(CGContextRef) context {
    CGContextSetLineWidth(context, 1.2);
    CGContextSetStrokeColorWithColor(context, [[NSColor blueColor] CGColor]);

    CGFloat midPoint = self.height/2;
    CGFloat x = self.stepSize;

    CGFloat value = [dataBuffer[0] floatValue];
    CGContextMoveToPoint(context, 0, midPoint + (value * self.unitSize));

    for(NSNumber *dataPoint in dataBuffer) {
        CGFloat value = [dataPoint floatValue];
        CGContextAddLineToPoint(context, x, midPoint + (value * self.unitSize));
        x += self.stepSize;
    }

    CGContextStrokePath(context);
}

- (void)drawQuarterLines:(CGContextRef)context {
    CGContextSetLineWidth(context, 0.8);
    CGContextSetStrokeColorWithColor(context, [[NSColor darkGrayColor] CGColor]);

    CGFloat quarterHeight = self.height/4;

    for(int i=1; i<4; i++) {
        [self drawLineFromPoint:CGPointMake(0, quarterHeight * i)
                        toPoint:CGPointMake(self.width, quarterHeight * i)
                    withContext:context];
    }

    CGContextStrokePath(context);
}

- (void)drawGridLines:(CGContextRef)context {
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[NSColor lightGrayColor] CGColor]);

    // Vertical Lines
    for(int i = 0; i < self.width/self.cellSize; i++) {
        CGFloat x = i*self.cellSize - (frameCount%kFPS) * self.stepSize;
        [self drawLineFromPoint:CGPointMake(x, 0)
                        toPoint:CGPointMake(x, self.height)
                    withContext:context];
    }

    // Horizontal Lines
    for(int i = 0; i < kVerticalCells; i++) {
        CGFloat y = i*self.cellSize;
        [self drawLineFromPoint:CGPointMake(0, y)
                        toPoint:CGPointMake(self.width, y)
                    withContext:context];
    }

    CGContextStrokePath(context);
}

- (void)drawLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint withContext:(CGContextRef)context {
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
}

@end
