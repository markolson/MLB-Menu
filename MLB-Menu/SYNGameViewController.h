//
//  GameViewController.h
//  MLB-Menu
//
//  Created by mark olson on 4/2/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SYNGameViewController : NSViewController {
    IBOutlet NSImageView *home;
    IBOutlet NSImageView *away;
    IBOutlet NSTableView *mediaSources;
    IBOutlet NSSegmentedControl *scoreBox;
}

@property (nonatomic, retain) NSDictionary *raw;

-(void)clicked;
@end
