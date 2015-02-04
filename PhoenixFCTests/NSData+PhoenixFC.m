//
//  NSData+PhoenixFC.m
//  PhoenixFC
//
//  Created by Colin Harris on 5/2/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "NSData+PhoenixFC.h"

SpecBegin(NSData)

describe(@"NSData", ^{
        
    describe(@"getIntegerWithRange", ^{
        
        it(@"returns the integer value of a single byte", ^{
            NSData *data = [@"5" dataUsingEncoding:NSASCIIStringEncoding];
            NSInteger result = [data getIntegerWithRange:NSMakeRange(0, 1)];
            expect(result).to.equal(5);
        });
        
        it(@"returns the integer value of multiple bytes", ^{
            NSData *data = [@"56" dataUsingEncoding:NSASCIIStringEncoding];
            NSInteger result = [data getIntegerWithRange:NSMakeRange(0, 2)];
            expect(result).to.equal(56);
        });
        
        it(@"returns the integer value when left padded by empty space", ^{
            NSData *data = [@" 567" dataUsingEncoding:NSASCIIStringEncoding];
            NSInteger result = [data getIntegerWithRange:NSMakeRange(0, 4)];
            expect(result).to.equal(567);
        });
        
    });
    
});

SpecEnd
