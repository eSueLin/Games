//
//  LYCountdownTimer.h
//  LYPuzzle
//
//  Created by HC16 on 2019/4/24.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LYCountdownTimerDelegate <NSObject>

- (void)countdownTimerbeRunofTime;

@end

@interface LYCountdownTimer : UIView

@property (nonatomic, assign) int totalTime;

@property (nonatomic, weak) id<LYCountdownTimerDelegate> delegate;

@property (nonatomic, weak) UILabel *textLabel;

- (instancetype)initWithTotalTime:(int)totalTime withLayoutLabel:(UILabel *)label;

- (void)turnOnTimer;

- (void)turnDownTimer;

@end

NS_ASSUME_NONNULL_END
