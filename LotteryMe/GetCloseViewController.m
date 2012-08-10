//
//  GetCloseViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 01.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "GetCloseViewController.h"

@interface GetCloseViewController ()
@property BOOL userDidTouch;
@property double currentBallSpeed;
@property NSMutableArray *result;
@end

@implementation GetCloseViewController
@synthesize ballImg = _ballImg;
@synthesize pointsLabel = _pointsLabel;
@synthesize centerLine = _centerLine;
@synthesize userDidTouch = _userDidTouch;
@synthesize currentBallSpeed = _currentBallSpeed;
@synthesize result = _result;

#define BALL_START_SPEED 0.9f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentBallSpeed = BALL_START_SPEED;
        
        _result = [[NSMutableArray alloc] initWithCapacity:self.player.count];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBallToBeginning];
    ((ZoomOutLabel*)self.pointsLabel).delegate = self;
    [self nextPlayer];
    [self animateBallWithSpeed:self.currentBallSpeed];
}

- (void)viewDidUnload
{
    [self setBallImg:nil];
    [self setPointsLabel:nil];
    [self setCenterLine:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.userDidTouch = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    // with the help of the presentation layer we receive the current position in the animation
    CALayer *presentationLayer = [self.ballImg.layer presentationLayer];
    double ballY = [presentationLayer position].y;
    
    [UIView setAnimationDuration:[presentationLayer duration]];
    
    double x = self.ballImg.frame.origin.x;
    double height = self.ballImg.frame.size.height;
    double width = self.ballImg.frame.size.width;
    self.ballImg.frame = CGRectMake(x, ballY, width, height);
    
    [UIView commitAnimations];
    
    int centerY = self.centerLine.frame.origin.y;
    int ballCenterY = self.ballImg.frame.origin.y;
    
    int points = 0;
    if (ballCenterY == centerY) {
        // ball is excatly in the middle
        points = 1000;
    } else {
        // ball either in in the upper or lower half
        points = centerY - (MAX(centerY, ballCenterY) - MIN(centerY, ballCenterY));
    }
    self.pointsLabel.hidden = NO;
    [self.pointsLabel display:[NSString stringWithFormat:@"%d", points]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: self.currentPlayer, KEY_PLAYER,
                         [NSNumber numberWithInt:(points)], KEY_POINTS, nil];
    [self.result addObject:dic];
    
    // next player
    if(![self nextPlayer]) {
        [self finishGame];
    }
}

- (void) finishGame {

    // show the result
    ResultViewController *resultView = [[ResultViewController alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:KEY_POINTS ascending:NO];
    
    NSArray *descriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [self.result sortUsingDescriptors:descriptors];
    [resultView setResult:self.result];
    [self.navigationController pushViewController:resultView animated:YES];
}

- (void) setBallToBeginning {
    int x = self.ballImg.frame.origin.x;
    int height = self.ballImg.frame.size.height;
    int width = self.ballImg.frame.size.width;
    
    self.ballImg.frame = CGRectMake(x, -47, width, height);
}
- (void) setBallToEnd {
    int x = self.ballImg.frame.origin.x;
    int height = self.ballImg.frame.size.height;
    int width = self.ballImg.frame.size.width;
    
    self.ballImg.frame = CGRectMake(x, 409, width, height);
}
- (void) animateBallWithSpeed:(double) speed {
    // Set ball starting point
    [self setBallToBeginning];
    
    // Setup animation
    [UIView beginAnimations:@"moveBall" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:speed];
    
    // Set delegate
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animateBallDidStop)];
    
    // Set final ball position
    [self setBallToEnd];
    
    // Run animation
    [UIView commitAnimations];
}

- (void) animateBallDidStop {
    if (!self.userDidTouch) {
        if(self.currentBallSpeed > 0) {
            self.currentBallSpeed -= 0.1f;
        }
        [self animateBallWithSpeed:self.currentBallSpeed];
    }
}

#pragma mark ZoomOutLabel callback
- (void) animationDidStop {
    // the animation which shows the next player did stop
    // we set back the state of 'userDidTouch' and start the ball animation again
    self.userDidTouch = NO;
    self.currentBallSpeed = BALL_START_SPEED;
    [self animateBallWithSpeed:self.currentBallSpeed];
}

@end
