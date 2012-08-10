//
//  BasicLotteryViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "BasicLotteryViewController.h"

@interface BasicLotteryViewController ()

@end

@implementation BasicLotteryViewController

@synthesize player = _player;
@synthesize playerLabel = _playerLabel;
@synthesize nextPlayerIndex = _nextPlayerIndex;
@synthesize currentPlayer = _currentPlayer;

- (int) maxAmoutOfPlayer{return -1;}

- (void)viewDidLoad {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] 
                                initWithTitle:@"Home" 
                                style:UIBarButtonItemStyleDone 
                                target:self 
                                action:@selector(pressedBack:)];
    
    self.navigationItem.leftBarButtonItem = backBtn;
}
- (void) pressedBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) nextPlayer {
    if(self.player.count > self.nextPlayerIndex) {
        self.playerLabel.hidden = NO;
        self.currentPlayer = [self.player objectAtIndex:self.nextPlayerIndex];
        if([self.playerLabel isMemberOfClass:[ZoomOutLabel class]]) {
            [(ZoomOutLabel*)self.playerLabel display: self.currentPlayer];
        } else {
            self.playerLabel.text = self.currentPlayer;
        }
        self.nextPlayerIndex++;
        
        return YES;
    }
    return NO;
}

@end
