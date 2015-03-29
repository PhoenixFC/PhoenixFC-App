//
//  RxWizardStep.m
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "RxWizardStep.h"

@implementation RxWizardStep

@synthesize label;
@synthesize transmitterImageName;
@synthesize animationSelector;

- (id)initWithLabel:(NSString *)aLabel imageName:(NSString *)imageName andSelector:(SEL)aSelector {
    if( self = [super init] ) {
        self.label = aLabel;
        self.transmitterImageName = imageName;
        self.animationSelector = aSelector;
    }
    return self;
}

@end
