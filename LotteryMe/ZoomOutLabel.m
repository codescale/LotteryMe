//
//  PlayerLabelView.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 03.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "ZoomOutLabel.h"

@interface ZoomOutLabel ()

@end

@implementation ZoomOutLabel

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) display:(NSString *)text {
    self.text = text;
    
    // we disable any useraction till the animation is over (see animationDidStop: )
    [self.superview setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(animatePlayerLabel) userInfo:nil repeats:NO];
}

- (void) animatePlayerLabel {
    
    // Begin a new transaction for the current thread
    [CATransaction begin];
    
    // Set the duration of the transaction
    [CATransaction setValue:[NSNumber numberWithFloat:1] forKey:kCATransactionAnimationDuration];
    
    // Create the scale animation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleAnimation.toValue = [NSNumber numberWithFloat:5.0];
    [[self layer] addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    // Create the fading animation
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    fadeAnimation.delegate = self; // order is important. This has to be before addAnimation:
    [[self layer] addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        self.hidden = YES;
        [self.superview setUserInteractionEnabled:YES];
        
        if(self.delegate) {
            [self.delegate animationDidStop];
        }
    }
}

@end
