//
//  SlotMachineViewController.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 16.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicLotteryViewController.h"

@interface SlotMachineViewController : BasicLotteryViewController

@property (weak, nonatomic) IBOutlet UIButton *metalButton;

- (IBAction)dragedMetalButton:(UIButton *)sender withEvent:(UIEvent *)event;
- (IBAction)dragExitMetalButton:(UIButton *)sender withEvent:(UIEvent *)event;
- (IBAction)tabStart;
- (IBAction)tabStop;

@end
