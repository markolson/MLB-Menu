//
//  SYNAppDelegate.h
//  MLB-Menu
//
//  Created by mark olson on 4/2/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SYNAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSMutableArray *gameArray;
}

@property (assign) IBOutlet NSWindow *window;


@end
