//
//  StrawPickViewController.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BasicLotteryViewController.h"

@interface StrawPickViewController : BasicLotteryViewController

@property (weak, nonatomic) IBOutlet UILabel *looserLabel;

- (IBAction)strawPressed:(id)sender;

@end
