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

#define kEndGamesList 1869

@implementation SYNAppDelegate

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];

    NSDictionary *fontattr;
    if ([[[[NSFontManager alloc] init] availableMembersOfFontFamily:@"Apple Color Emoji"] objectAtIndex:0]) {
        fontattr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Apple Color Emoji" size:13] forKey:NSFontAttributeName];
    }else{
        fontattr = @{};
    }
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"⚾" attributes:fontattr];
    
    [statusItem setAttributedTitle:title];
    [statusItem setEnabled:YES];
    [statusItem setHighlightMode:YES];
    [statusMenu setDelegate:self];
}

-(IBAction)updateGames:(id)sender {
    time_t currentTime = time(NULL);
    struct tm timeStruct;
    localtime_r(&currentTime, &timeStruct);
    char buffer[26];
    strftime(buffer, 26, "year_%Y/month_%m/day_%d", &timeStruct);
    NSString *url = [NSString stringWithFormat:@"http://mlb.mlb.com/gdcross/components/game/mlb/%s/grid.json", buffer];
    [self parseURL:url];
}

-(void)parseURL:(NSString*)theURL {
    NSLog(@"%@", theURL);
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:theURL]];
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
    NSArray *json_games = (NSMutableArray *)parsed[@"data"][@"games"][@"game"];
    
    for (NSMenuItem *item in [statusMenu itemArray]){
        if(item.tag >= kEndGamesList){
            break;
        } else {
            [statusMenu removeItem:item];
        }
    }
    
    for (NSDictionary *g in [json_games reverseObjectEnumerator]) {
        [self addGame:g];
    }
}

-(void)addGame:(NSDictionary *)gamedict {
    NSMenuItem *game = [[NSMenuItem alloc]
                        initWithTitle:[NSString stringWithFormat:@"%@ @ %@", gamedict[@"away_team_name"], gamedict[@"home_team_name"]]
                        action:nil
                        keyEquivalent:@""];
    
    SYNGameViewController *gv = [[SYNGameViewController alloc] init];
    [game setView:gv.view];
    [game setEnabled:YES];
    [game setTag:0];
    [gv setRaw:gamedict];
    [statusMenu insertItem:game atIndex:0];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSTimer scheduledTimerWithTimeInterval:(60.0 * 2) target:self selector:@selector(updateGames:) userInfo:nil repeats:YES];
    [self updateGames:nil];

}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    //NSLog(@"%@", item);
}

@end
