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
    // there are some days that just have single games, and use a different structure.
    // a really stupid structure, actually. This is pretty horrible code because it's actually
    // either a dictionary or an array. I should be able to introspect this. Maybe Swift will let me??
    id json_games = parsed[@"data"][@"games"][@"game"];
    NSMutableArray *gameList = [[NSMutableArray alloc] init];

    // there is only a single game today if it's a dictionary
    if ([json_games isKindOfClass: [NSDictionary class]]) {
        [gameList addObject:json_games];
    }else{
        gameList = (NSMutableArray *)json_games;
    }
    
    for (NSMenuItem *item in [statusMenu itemArray]){
        if(item.tag >= kEndGamesList){
            break;
        } else {
            [statusMenu removeItem:item];
        }
    }
    
    for (NSDictionary *g in [gameList reverseObjectEnumerator]) {
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
    updater = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:0.1] interval:30.0 target:self selector:@selector(updateGames:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:updater forMode:NSRunLoopCommonModes];
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    //NSLog(@"%@", item);
}

@end
