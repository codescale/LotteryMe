//
//  PlayerList.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 13.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerList : NSObject {
    @private
    NSMutableSet *playerList;
}

+ (PlayerList*) instance;

- (NSArray *) getPlayer;

- (void) addPlayer:(NSString *) playerName;
- (void) addPlayers:(NSArray *) playerNames;

/**
 * Add the given player and return YES if the player was in the list and has been removed.
 **/
- (BOOL) removePlayer:(NSString *) playerName;

@end

PlayerList *instance;