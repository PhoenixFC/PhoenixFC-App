//
//  TransmitterView.m
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "TransmitterView.h"

@implementation TransmitterView

@synthesize imageView;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.image = [NSImage imageNamed:@"Radio_Blank"];
    }
    return self;
}

@end
