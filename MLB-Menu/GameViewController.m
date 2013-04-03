//
//  GameViewController.m
//  MLB-Menu
//
//  Created by mark olson on 4/2/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import "GameViewController.h"
#import "SYNGameView.h"

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize raw;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)setHomeLogo:(NSImage *)_homeLogo {
    [home setImage:_homeLogo];
}
- (void)setAwayLogo:(NSImage *)_awayLogo {
    [away setImage:_awayLogo];
}

-(void)setStartTime:(NSString *)time {
    [gametime setStringValue:[NSString stringWithFormat:@"%@", time]];
}

-(void)clicked {
    //http://mlb.mlb.com/mlb/gameday/index.jsp?gid=2013_04_03_bosmlb_nyamlb_1&mode=gameday
    NSMutableString *url = [raw[@"id"] mutableCopy];
    [url replaceOccurrencesOfString:@"/" withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [url length])];
    [url replaceOccurrencesOfString:@"-" withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [url length])];
    url = [NSString stringWithFormat:@"http://mlb.mlb.com/mlb/gameday/index.jsp?gid=%@&mode=gameday", url];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}

@end
