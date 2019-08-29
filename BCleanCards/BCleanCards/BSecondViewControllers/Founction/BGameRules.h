//
//  BGameRules.h
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^CleanedCardstoAddTime)(int cleanNum);
@interface BGameRules : NSObject

+ (BGameRules *)defaultRules;

@property (nonatomic, copy) CleanedCardstoAddTime cleanedCards;

- (void)dataWithScoreLabel:(UILabel *)label superView:(UIView *)superView;

- (void)gameRulesWithAlignPokesArr:(NSMutableArray *)alignArr column:(NSMutableArray *)columnArr pokersArr:(NSMutableArray *)pokersArr;

- (NSInteger)insertDatatoCollectionforGameRule:(NSInteger)statical withCollectionArr:(NSMutableArray *)collectArr withInsertArr:(NSArray*)insertArr;

@end

NS_ASSUME_NONNULL_END
