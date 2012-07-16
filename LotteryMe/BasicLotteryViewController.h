//
//  BasicLotteryViewController.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomOutLabel.h"

@interface BasicLotteryViewController : UIViewController {
    @private
    NSArray *_player;
}

@property (retain, nonatomic) NSString *currentPlayer;
@property (retain, nonatomic) NSArray *player;
@property (weak, nonatomic) IBOutlet ZoomOutLabel *playerLabel;

- (int) maxAmoutOfPlayer;

- (BOOL) nextPlayer;

@end
