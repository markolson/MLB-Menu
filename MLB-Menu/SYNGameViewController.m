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
    if([raw[@"inning"] isEqualToString:@""]) {
        [scoreBox setSegmentCount:1];
        [scoreBox setLabel:raw[@"event_time"] forSegment:0];
        [scoreBox setWidth:96 forSegment:0];
    }else{
        [scoreBox setLabel:raw[@"away_score"] forSegment:0];
        [scoreBox setLabel:raw[@"home_score"] forSegment:2];
        if([raw[@"status"] isEqualToString:@"Final"]) {
            [scoreBox setLabel:@"Final" forSegment:1];
        }else{
            NSString *tb = ([raw[@"top_inning"] isEqualToString:@"Y"]) ? @"Top" : @"Bot";
            [scoreBox setLabel:[NSString stringWithFormat:@"%@ %@%@", tb, raw[@"inning"], [self ordinalFor:raw[@"inning"]]] forSegment:1];
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
