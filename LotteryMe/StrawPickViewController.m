//
//  StrawPickViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "StrawPickViewController.h"

@interface StrawPickViewController ()

@end

@implementation StrawPickViewController
@synthesize looserLabel = _looserLabel;

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
    
    // Set the title
    self.navigationItem.title = @"Drawing straws";

    // get a random number to define a random shorter straw
    int shortStrawIndex = arc4random() % self.player.count;
    
#define STRAW_WIDTH 59
    int totalWidth = self.player.count * STRAW_WIDTH;
    int x = self.view.bounds.size.width / 2 - totalWidth / 2; // This helps to position the straws center aligned
    for (int i = 0; i < self.player.count; i++) {
        
        // Create a button
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, -167, STRAW_WIDTH, 360)];
        
        if(i == shortStrawIndex) {
            [btn setImage:[UIImage imageNamed:@"short-straw.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(shortStrawPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn setImage:[UIImage imageNamed:@"straw.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(strawPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.view addSubview:btn];
        
        x += STRAW_WIDTH; // everytime we move the next straw 40points to the right
    }
    
    // Bring player and looser label to the front
    [self.view bringSubviewToFront:self.playerLabel];
    [self.view bringSubviewToFront:self.looserLabel];
    // And display the next (in this case first) player
    [self nextPlayer];
}

- (void)viewDidUnload
{
    [self setPlayerLabel:nil];
    [self setLooserLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (int)maxAmoutOfPlayer {
    return 5;
}

#pragma mark Handle straw
- (IBAction)strawPressed:(UIButton *)sender {
    [self animateStraw:sender andShowNextPlayer:YES];
}

- (IBAction)shortStrawPressed:(UIButton *)sender {
    // the game is over, so no other user action allowed
    [self.view setUserInteractionEnabled:NO];
    
    [self animateStraw:sender andShowNextPlayer:NO];
    
    self.looserLabel.hidden = NO;
}

- (void) animateStraw:(UIButton *)sender andShowNextPlayer:(BOOL)isNextPlayer {
    
    // this straw is not allow to be touched again
    [sender setUserInteractionEnabled:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0f];
    if(isNextPlayer) {
        [self nextPlayer];
    }
    
    CGRect buttonFrame = sender.frame;
    [sender setFrame:CGRectMake(buttonFrame.origin.x, 0, buttonFrame.size.width, buttonFrame.size.height)];
    
    [UIView commitAnimations];
}

@end
