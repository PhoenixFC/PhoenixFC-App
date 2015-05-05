//
//  MainWindowController.m
//  PhoenixFC
//
//  Created by Colin Harris on 4/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.titleVisibility = NSWindowTitleVisible;
}

- (IBAction)toggle:(id)sender {
    NSLog(@"toggle clicked!");
}

@end
