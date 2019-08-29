//
//  MWTimer.h
//  MentalWork
//
//  Created by HC16 on 5/17/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kMWTimerOverTime = @"overTime";

typedef void(^MWTiming)(NSString *timeStr);
@interface MWTimer : NSObject

@property (nonatomic, copy) MWTiming timing;

+ (MWTimer *)defaultTimer;

- (NSString *)timeDown:(NSString *)time;

- (NSString *)timerTurnDown:(NSString *)time;

- (void)timerTurnOut;

- (void)timerTurnOn:(NSString *)time;


@end

NS_ASSUME_NONNULL_END
