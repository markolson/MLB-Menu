//
//  SYNAppDelegate.m
//  MLB-Menu
//
//  Created by mark olson on 4/2/13.
//  Copyright (c) 2013 Syntaxi. All rights reserved.
//

#import "SYNAppDelegate.h"
#import "SYNGameViewController.h"
#import "time.h"

@implementation SYNAppDelegate

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];

    [statusItem setImage:[NSImage imageNamed:@"ball.png"]];
}

-(void)parseURL:(NSString*)theURL {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:theURL]];
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    NSArray *json_games = (NSMutableArray *)parsed[@"data"][@"games"][@"game"];
    
    for (NSDictionary *g in [json_games reverseObjectEnumerator]) {
        [self addGame:g];
    }
}

-(void)addGame:(NSDictionary *)gamedict {
    [statusItem setHighlightMode:YES];
    NSMenuItem *game = [[NSMenuItem alloc]
                        initWithTitle:[NSString stringWithFormat:@"%@ @ %@", gamedict[@"away_team_name"], gamedict[@"home_team_name"]]
                        action:nil
                        keyEquivalent:@""];
    
    SYNGameViewController *gv = [[SYNGameViewController alloc] init];
    [game setView:gv.view];
    [gv setHomeLogo:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", gamedict[@"home_file_code"]]]];
    [gv setAwayLogo:[NSImage imageNamed:[NSString stringWithFormat:@"%@.png", gamedict[@"away_file_code"]]]];
    [gv setStartTime:gamedict[@"event_time"]];
    [gv setRaw:gamedict];
    [statusItem setEnabled:YES];
    [statusItem setHighlightMode:YES];
    [statusMenu insertItem:game atIndex:0];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    time_t currentTime = time(NULL);
    struct tm timeStruct;
    localtime_r(&currentTime, &timeStruct);
    char buffer[26];
    strftime(buffer, 26, "year_%Y/month_%m/day_%d", &timeStruct);
    NSString *url = [NSString stringWithFormat:@"http://mlb.mlb.com/gdcross/components/game/mlb/%s/grid.json", buffer];
    [self parseURL:url];
}

@end
