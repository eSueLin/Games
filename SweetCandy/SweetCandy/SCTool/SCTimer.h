//
//  SCTimer.h
//  SweetCandy
//
//  Created by HC16 on 6/5/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SCTimeRunning)(NSString *timeUp);
@interface SCTimer : NSObject

@property (nonatomic, copy) SCTimeRunning timerGone;

+ (SCTimer*)defaultTimer;

- (void)timerStart;

- (void)timerStop:(void(^)(int usedtime, NSString *timerStr))endGame;

@end

NS_ASSUME_NONNULL_END
