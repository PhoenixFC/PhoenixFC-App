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

- (IBAction)connectClicked:(id)sender {
    NSLog(@"connectClicked:");
    _connectToolbarItem.label = @"Disconnect";
    [_connectToolbarItem setAction:@selector(disconnectClicked:)];
}

- (IBAction)disconnectClicked:(id)sender {
    NSLog(@"disconnectClicked:");
    _connectToolbarItem.label = @"Connect";
    [_connectToolbarItem setAction:@selector(connectClicked:)];
}

@end
