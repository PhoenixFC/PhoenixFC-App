//
//  MainWindowController.h
//  PhoenixFC
//
//  Created by Colin Harris on 4/3/15.
//  Copyright (c) 2015 Colin Harris. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController

@property (nonatomic, weak) IBOutlet NSToolbarItem *connectToolbarItem;

- (IBAction)connectClicked:(id)sender;
- (IBAction)disconnectClicked:(id)sender;

@end
