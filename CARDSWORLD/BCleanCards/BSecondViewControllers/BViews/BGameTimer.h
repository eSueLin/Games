//
//  BGameTimer.h
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BGameTimerDelegate <NSObject>

- (void)countdownTimerbeRunofTime;

@end

@interface BGameTimer : UIView

@property (nonatomic, assign) int totalTime;

@property (nonatomic, weak) id<BGameTimerDelegate> delegate;

@property (nonatomic, weak) UILabel *textLabel;

- (instancetype)initWithTotalTime:(int)totalTime;

- (void)turnOnTimer;

- (void)turnDownTimer;

- (void)addTime:(int)time;

@end

NS_ASSUME_NONNULL_END
