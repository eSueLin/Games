//
//  BScoreStatic.h
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kCleanCardsScore = @"cleanCardsScore";

@interface BScoreStatic : NSObject

+ (BScoreStatic *)shareInstance;

- (void)saveScore:(NSString *)score;

- (NSArray *)getScore;

@end

NS_ASSUME_NONNULL_END
