//
//  PlayerList.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 13.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "PlayerList.h"

# define KEY_PLAYERLIST @"playerList"

@implementation PlayerList

+ (PlayerList*) instance {
    if(!instance) {
        instance = [[PlayerList alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [userDefaults objectForKey:KEY_PLAYERLIST];
        if (data != nil)
        {
            NSArray *previousUserList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [instance addPlayers:previousUserList];
        }
    }
    return instance;
}

- (id) init
{
    self = [super init];
    if (self) {
        playerList = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void) store
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:playerList.allObjects] forKey:KEY_PLAYERLIST];
    [userDefaults synchronize];
}

- (NSArray *) getPlayer {
    return playerList.allObjects;
}

- (void) addPlayer:(NSString *) playerName {
    [playerList addObject:playerName];
    [self store];
}

- (void) addPlayers:(NSArray *) playerNames {
    [playerList addObjectsFromArray:playerNames];
    [self store];
}

- (BOOL) removePlayer:(NSString *) playerName {
    if ([playerList containsObject:playerName]) {
        [playerList removeObject:playerName];
        [self store];
        return  YES;
    }
    return NO;
}

@end
