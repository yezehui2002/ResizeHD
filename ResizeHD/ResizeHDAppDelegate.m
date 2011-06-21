//
//  ResizeHDAppDelegate.m
//  ResizeHD
//
//  Created by ipalmer on 20/06/11.
//  Copyright 2011 BakingCode. All rights reserved.
//

#import "ResizeHDAppDelegate.h"

@implementation ResizeHDAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    exit(0);
    return YES;
}

@end
