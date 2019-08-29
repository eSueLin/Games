//
//  SCTimerUsedStore.h
//  SweetCandy
//
//  Created by HC16 on 6/5/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTimerUsedStore : NSObject

+ (SCTimerUsedStore *)defaultTimerUserd;

- (void)saveStage:(int)level usedTime:(int)timeSec timeString:(NSString *)timeStr;

- (NSArray *)getBestScoreWithStage:(int)level;

@end

NS_ASSUME_NONNULL_END
