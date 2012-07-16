//
//  SlotMachineViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 16.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "SlotMachineViewController.h"

@interface SlotMachineViewController ()

@end

@implementation SlotMachineViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dragedMetalButton:(UIButton *)sender {
    
    NSLog(@"Metal button got dragged");
    
}

@end
