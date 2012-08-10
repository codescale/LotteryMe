//
//  PickACardViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 20.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "PickACardViewController.h"

@interface PickACardViewController ()
@property NSMutableArray* playCards;
@property UIView* loserPlayCard;
@end

@implementation PickACardViewController
@synthesize playCards = _playCards;
@synthesize loserPlayCard = _loserPlayCard;

const char* cardFrontArray[9] = {"PickACard_card_ass_club","PickACard_card_ass_diamond","PickACard_card_ass_spade","PickACard_card_ass_heart","PickACard_card_king_club","PickACard_card_king_diamond","PickACard_card_king_spade","PickACard_card_king_heart"};

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
    
    // get a random number to define a random place for the looser card
    int looserCardIndex = arc4random() % self.player.count;
    
    // 189 = 320 - 5 - 121 - 5
    // 320 width in total
    // 5 gap on each side
    // 121 width of a card
    float gapBetweenCards = 189 / (float)(self.player.count - 1);
    
    int frontCardIndex = 0;
    for (int i = 0; i < self.player.count; i++) {
        if(looserCardIndex == i) {
            // add the looser card
            self.loserPlayCard = [self createNewPlayCard:i*gapBetweenCards 
                                            withFrontImg:[UIImage imageNamed:@"PickACard_card_loser.png"]];
            [self.view addSubview:self.loserPlayCard];
        } else {
            // add a usual card
            UIView *view = [self createNewPlayCard:i*gapBetweenCards 
                                      withFrontImg:[UIImage imageNamed:[NSString stringWithUTF8String:cardFrontArray[frontCardIndex]]]];
            [self.view addSubview:view];
            [self.playCards addObject:view];
            frontCardIndex++;
        }
    }
    
    [self nextPlayer];
}
- (UIView*)createNewPlayCard:(float)x withFrontImg:(UIImage*)frontImg {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x + 5, 150, 121, 198)];
    
    UIImageView *front = [[UIImageView alloc] initWithImage:frontImg];
    [view addSubview:front];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 121, 198)];
    [button setImage:[UIImage imageNamed:@"PickACard_card_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTouchCard:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

- (void)viewDidUnload
{
    self.playCards = nil;
    self.loserPlayCard = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (int)maxAmoutOfPlayer {
    return 9;
}

- (void)didTouchCard:(UIButton*)sender {
    
    [self.view setUserInteractionEnabled:NO];
    
    [UIView beginAnimations:@"move card up" context:(void*)sender.superview];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(flipCard:finished:context:)];
    
    [sender.superview.superview bringSubviewToFront:sender.superview];
    sender.superview.center = CGPointMake(sender.superview.center.x, 120);
    
    [UIView commitAnimations];
}
- (void)flipCard:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    
    UIView *cardBack = (__bridge UIView*) context;
    
    [UIView beginAnimations:@"flip card" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:cardBack cache:YES];
    
    if(cardBack != self.loserPlayCard) {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(flipCardDidStop:finished:context:)];
    }
    
    [[[cardBack subviews] objectAtIndex:1] setHidden:YES];
    
    [UIView commitAnimations];
}
- (void)flipCardDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    [self nextPlayer];
    [self.view setUserInteractionEnabled:YES];
}

@end
