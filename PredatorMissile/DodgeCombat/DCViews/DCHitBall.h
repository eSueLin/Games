//
//  DCHitBall.h
//  DodgeCombat
//
//  Created by HC16 on 5/26/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHitBallOrien)
{
    DCHitBallAcrossRight = 0,
    DCHitBallAcrossLeft ,
    DCHitBallVerticalDown,
    DCHitBallVerticalUp,
};

NS_ASSUME_NONNULL_BEGIN

@interface DCHitBall : NSObject

+ (UIImageView *)addHitBall:(UIView*)gameArea screenViewSize:(CGSize)screenSize  runningOrien:(void(^)(DCHitBallOrien orien, UIImageView *ball))runingOrien;

+ (void)hitBallRunningWithBallsArr:(NSMutableArray *)arr level:(int)level inGameArea:(UIView *)gameArea willDetermin:(void(^)(UIImageView *runningball))determinBlock;


@end

NS_ASSUME_NONNULL_END
