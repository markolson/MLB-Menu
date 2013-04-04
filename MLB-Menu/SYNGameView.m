//
//  SYNGameView.m
//  MLB-Menu
//
//  Created by mark olson on 4/4/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import "SYNGameView.h"

@implementation SYNGameView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    [controller clicked];
}
@end
