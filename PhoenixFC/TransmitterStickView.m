//
//  TransmitterStickView.m
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "TransmitterStickView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransmitterStickView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
 
    NSGraphicsContext *graphicsContext = [NSGraphicsContext currentContext];
    CGContextRef ctx = (CGContextRef)[graphicsContext graphicsPort];
    
    CGRect borderRect = CGRectMake(3, 3, 14, 14);
    CGContextSetStrokeColorWithColor(ctx, [NSColor blueColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [NSColor blueColor].CGColor);
    CGContextFillEllipseInRect(ctx, borderRect);
    CGContextFillPath(ctx);    
}

@end
