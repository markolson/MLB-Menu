//
//  GameViewController.m
//  MLB-Menu
//
//  Created by mark olson on 4/2/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import "SYNGameViewController.h"
#import "SYNGameView.h"

@interface SYNGameViewController ()

@end

@implementation SYNGameViewController
@synthesize raw;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)setRaw:(NSDictionary *)_raw {
    raw = _raw;
    [home setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", raw[@"home_file_code"]]]];
    [away setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", raw[@"away_file_code"]]]];
    [gametime setStringValue:[NSString stringWithFormat:@"%@", raw[@"event_time"]]];
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
