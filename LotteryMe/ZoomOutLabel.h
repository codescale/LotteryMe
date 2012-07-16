//
//  PlayerLabelView.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 03.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ZoomOutLabelDelegate <NSObject>

- (void) animationDidStop;

@end

@interface ZoomOutLabel : UILabel

@property id delegate;

- (void) display:(NSString*)text;

@end