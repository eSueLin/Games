//
//  BYTimer.h
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BYTimerReportDelegete <NSObject>

- (void)reportUseTime:(int)time;

@end

typedef void (^timerBlock)(int time);

@interface BYTimer : UIView

@property (nonatomic, copy) timerBlock tblock;

@property (nonatomic, assign) int usedTime;

- (void)timerStart;

- (void)timerStop;

- (void)clearTimer;


@end

NS_ASSUME_NONNULL_END
