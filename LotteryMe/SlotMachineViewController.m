//
//  SlotMachineViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 16.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "SlotMachineViewController.h"

@interface SlotMachineViewController ()
@property double animationDuration;
@property BOOL isSlotMachineStopping,isSlotMachineRunning;
@end

@implementation SlotMachineViewController
@synthesize metalButton = _metalButton;
@synthesize animationDuration = _animationDuration;
@synthesize isSlotMachineStopping = _isSlotMachineStopping;
@synthesize isSlotMachineRunning = _isSlotMachineRunning;

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
    [self.metalButton.layer addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(object == self.metalButton.layer && [keyPath isEqual:@"position"]) {
        [self observeMetalButton:change];
    }
}

- (void)viewDidUnload
{
    [self setMetalButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Handling for the round button

#define BUTTON_MAX_Y 366
#define BUTTON_MIDDLE_Y 306
#define BUTTON_MIN_Y 246
#define BUTTON_X 160
- (IBAction)dragedMetalButton:(UIButton *)sender withEvent:(UIEvent *)event {
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    if(point.y > BUTTON_MIN_Y && point.y < BUTTON_MAX_Y) {
        // the drag point is in between min and max of the slider
        sender.center = CGPointMake(BUTTON_X, point.y);
    } else {
        // the drag point is below or above min or max 
        // so we move the slider directly to the min or max of the slider
        if(point.y < BUTTON_MIN_Y) {
            sender.center = CGPointMake(BUTTON_X, BUTTON_MIN_Y);
        } else if (point.y > BUTTON_MAX_Y) {
            sender.center = CGPointMake(BUTTON_X, BUTTON_MAX_Y);
        }
    }
    
}
- (IBAction)dragExitMetalButton:(UIButton *)sender withEvent:(UIEvent *)event {
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    if(point.y <= BUTTON_MIDDLE_Y) {
        // button is on the upper half -> move the button all the way back to the top
        [self moveButton:sender to:CGPointMake(BUTTON_X, BUTTON_MIN_Y)];
    } else {
        // button must be in the lower half -> move the button all the way to the bottom
        [self moveButton:sender to:CGPointMake(BUTTON_X, BUTTON_MAX_Y)];
    }
}
- (IBAction)tabStart {
    [self moveButton:self.metalButton to:CGPointMake(BUTTON_X, BUTTON_MAX_Y)];
}
- (IBAction)tabStop {
    [self moveButton:self.metalButton to:CGPointMake(BUTTON_X, BUTTON_MIN_Y)];
}
- (void)moveButton:(UIButton *)button to:(CGPoint)point {
    
    [UIView beginAnimations:@"Move button" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    button.center = point;
    
    [UIView commitAnimations];
}
- (void)observeMetalButton:(NSDictionary*)change {
    if(self.metalButton.layer.position.y == BUTTON_MAX_Y) {
        [self startSlotMachine];
    } else if(self.metalButton.layer.position.y == BUTTON_MIN_Y) {
        [self stopSlotMachine];
    }
}

#pragma mark slot machine states

#define NAME_LABEL_TOP_Y 122
#define NAME_LABEL_BOTTOM_Y 219
#define NAME_LABEL_MIDDLE_Y 170
#define NAME_LABEL_X 158
#define ANIMATION_DURATION_START 0.2f
#define ANIMATION_DURATION_END 1.0f
- (void)startSlotMachine {
    
    if(self.isSlotMachineRunning) {
        // let it machine keep running
        return;
    }
    
    self.isSlotMachineRunning = YES;
    self.isSlotMachineStopping = NO;
    self.animationDuration = ANIMATION_DURATION_START;
    [self rotateNameLabel];
}
- (void)stopSlotMachine {
    self.isSlotMachineStopping = YES;
}
- (void)rotateNameLabel {
    
    // set the location to the top
    self.playerLabel.center = CGPointMake(NAME_LABEL_X, NAME_LABEL_TOP_Y);
    
    // set the next player
    if(![self nextPlayer]) {
        // keep to repeat all the player
        super.nextPlayerIndex = 0;
        [self nextPlayer];
    }
    
    if((float)self.animationDuration < ANIMATION_DURATION_END) {
        // let the name rotate
        [UIView beginAnimations:@"rotate name label" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:self.animationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(nameLabelReachedBottom:finished:context:)];
        
        self.playerLabel.center = CGPointMake(NAME_LABEL_X, NAME_LABEL_BOTTOM_Y);
        
        [UIView commitAnimations];
        
        if(self.isSlotMachineStopping) {
            self.animationDuration += 0.1f;
        }
    } else {
        // end rotation animation
        self.isSlotMachineRunning = NO;
        // and let the last name bounce a bit
        [self bounceNameLabel:0];
    }
}
- (void)nameLabelReachedBottom:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    // repeat to get an infinit roation of the name label
    [self rotateNameLabel];
}
static int bouncePoints[] = {+20,-10,+5,0};
- (void)bounceNameLabel:(int)index {
    
    if(index >= sizeof(bouncePoints)/sizeof(int)) {
        // bouncing is finished
        return;
    }
    
    [UIView beginAnimations:@"bounce name label" context:(void*)index];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceDidStop:finished:context:)];
    
    self.playerLabel.center = CGPointMake(NAME_LABEL_X, NAME_LABEL_MIDDLE_Y + bouncePoints[index]);
    
    [UIView commitAnimations];
}
- (void)bounceDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    int index = (int)context + 1;
    [self bounceNameLabel:index];
}
@end
