//
//  GetCloseViewController.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 01.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BasicLotteryViewController.h"
#import "ResultViewController.h"

@interface GetCloseViewController : BasicLotteryViewController <ZoomOutLabelDelegate>

#define KEY_PLAYER @"player"
#define KEY_POINTS @"points"

@property (weak, nonatomic) IBOutlet UILabel *ballImg;
@property (weak, nonatomic) IBOutlet ZoomOutLabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLine;

@end
