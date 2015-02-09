//
//  RxWizardStep.h
//  PhoenixFC
//
//  Created by Colin Harris on 9/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RxWizardStep : NSObject

@property (retain) NSString *label;
@property (retain) NSString *transmitterImageName;
@property (assign) SEL animationSelector;

- (id)initWithLabel:(NSString *)aLabel imageName:(NSString *)imageName andSelector:(SEL)aSelector;

@end
