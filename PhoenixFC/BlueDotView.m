//
//  BlueDotView.m
//  PhoenixFC
//
//  Created by Colin Harris on 8/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "BlueDotView.h"

@implementation BlueDotView

- (void)drawRect:(NSRect)dirtyRect {
    // Get the graphics context that we are currently executing under
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    // Save the current graphics context settings
    [gc saveGraphicsState];
    
    // Set the color in the current graphics context for future draw operations
    [[NSColor blueColor] setStroke];
    [[NSColor blueColor] setFill];
    
    // Create our circle path
    NSRect rect = NSMakeRect(3, 3, 14, 14);
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: rect];
    
    // Outline and fill the path
    [circlePath stroke];
    [circlePath fill];
    
    // Restore the context to what it was before we messed with it
    [gc restoreGraphicsState];
}

@end
