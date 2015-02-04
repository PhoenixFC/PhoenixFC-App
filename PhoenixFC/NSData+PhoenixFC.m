//
//  NSData+PhoenixFC.m
//  PhoenixFC
//
//  Created by Colin Harris on 5/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "NSData+PhoenixFC.h"

@implementation NSData (PhoenixFC)

- (NSInteger)getIntegerWithRange:(NSRange)range {
    // TODO: Is there a more efficient way to do this ?
    NSString *value = [[NSString alloc] initWithData:[self subdataWithRange:range] encoding:NSASCIIStringEncoding];
    return [value intValue];
}

@end
