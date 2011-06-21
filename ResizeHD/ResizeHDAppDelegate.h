//
//  ResizeHDAppDelegate.h
//  ResizeHD
//
//  Created by ipalmer on 20/06/11.
//  Copyright 2011 BakingCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResizeHDAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
}

@property (strong) IBOutlet NSWindow *window;

@end
