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
    if([raw[@"status"][@"status"] isEqualToString:@"Scheduled"] || [raw[@"status"][@"status"] isEqualToString:@"Preview"] || [raw[@"status"][@"status"] isEqualToString:@"Pre-Game"] || [raw[@"status"][@"status"] isEqualToString:@"Warmup"]) {
        [scoreBox setSegmentCount:1];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@ %@", raw[@"home_time"], raw[@"home_time_zone"]] forSegment:0];
        [scoreBox setWidth:96 forSegment:0];
    }else if ([raw[@"status"][@"status"] isEqualToString:@"Delayed Start"] || [raw[@"status"][@"status"] isEqualToString:@"Delayed"] || [raw[@"status"][@"status"] isEqualToString:@"Cancelled"] || [raw[@"status"][@"status"] isEqualToString:@"Postponed"]) {
        [scoreBox setSegmentCount:1];
        [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"status"][@"status"]] forSegment:0];
        [scoreBox setWidth:96 forSegment:0];
    }else{
        [scoreBox setLabel:raw[@"linescore"][@"r"][@"away"] forSegment:0];
        [scoreBox setLabel:raw[@"linescore"][@"r"][@"home"] forSegment:2];
        if([raw[@"status"][@"status"] isEqualToString:@"In Progress"]) {
            NSString *tb = ([raw[@"status"][@"inning_state"] isEqualToString:@"Top"]) ? @"▲" : @"▼";
            [scoreBox setLabel:[NSString stringWithFormat:@"%@%@ %@", raw[@"inning"], [self ordinalFor:raw[@"inning"]], tb] forSegment:1];
        }else if([raw[@"status"][@"status"] isEqualToString:@"Final"] || [raw[@"status"][@"status"] isEqualToString:@"Game Over"]) {
             [scoreBox setLabel:@"Final" forSegment:1];
        }else {
            [scoreBox setLabel:[NSString stringWithFormat:@"%@", raw[@"status"][@"status"]] forSegment:1];
        }
    }
}

-(NSString *)ordinalFor:(NSString *)str {
    NSString *lastDigit = [str substringFromIndex:([str length]-1)];
    if ([str isEqualToString:@"11"] || [str isEqualToString:@"12"] || [str isEqualToString:@"13"]) {
        return @"th";
    } else if ([lastDigit isEqualToString:@"1"]) {
        return @"st";
    } else if ([lastDigit isEqualToString:@"2"]) {
        return @"nd";
    } else if ([lastDigit isEqualToString:@"3"]) {
        return @"rd";
    } else {
        return @"th";
    }
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
