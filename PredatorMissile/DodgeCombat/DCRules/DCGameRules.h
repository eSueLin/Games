//
//  DCGameRules.h
//  DodgeCombat
//
//  Created by HC16 on 5/29/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Catogary/CatogaryHeader.h"
#import "../DCViews/DCHitBall.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCGameRules : NSObject

+ (DCGameRules *)defaultGameRules;

- (UIImageView *)showHitballsWithLevel:(int)level  hitball:(UIImageView *)ball gameAreaView:(UIView *)gameArea orien:(DCHitBallOrien)orien;

@end

NS_ASSUME_NONNULL_END
