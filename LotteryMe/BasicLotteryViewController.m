//
//  BasicLotteryViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "BasicLotteryViewController.h"

@interface BasicLotteryViewController ()

@property int nextPlayerIndex;

@end

@implementation BasicLotteryViewController

@synthesize player = _player;
@synthesize playerLabel = _playerLabel;
@synthesize nextPlayerIndex = _nextPlayerIndex;
@synthesize currentPlayer = _currentPlayer;

- (int) maxAmoutOfPlayer{return -1;}

- (BOOL) nextPlayer {
    if(self.player.count > self.nextPlayerIndex) {
        self.playerLabel.hidden = NO;
        self.currentPlayer = [self.player objectAtIndex:self.nextPlayerIndex];
        [self.playerLabel display: [NSString stringWithFormat:@"%@", self.currentPlayer]];
        self.nextPlayerIndex++;
        
        return YES;
    }
    return NO;
}

@end
