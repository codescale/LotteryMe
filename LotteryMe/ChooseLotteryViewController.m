//
//  ChooseLotteryViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 26.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "ChooseLotteryViewController.h"

@interface ChooseLotteryViewController ()

@end

@implementation ChooseLotteryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Lottery";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)lotteryPressed:(UIButton *)sender {
    
    Class gameControllerClass;
    if ([sender.titleLabel.text isEqual:@"Straw Pick"]) {
        gameControllerClass = [StrawPickViewController class];
    } else if([sender.titleLabel.text isEqualToString:@"GetClose"]) {
        gameControllerClass = [GetCloseViewController class];
    } else if([sender.titleLabel.text isEqualToString:@"SlotMachine"]) {
        gameControllerClass = [SlotMachineViewController class];
    }
    
    PeoplePickerViewController *picker = [[PeoplePickerViewController alloc] initWithNextController:[[gameControllerClass alloc] init]];
    [self.navigationController pushViewController:picker animated:true];
}

@end
