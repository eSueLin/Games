//
//  DCGameView.h
//  DodgeCombat
//
//  Created by HC16 on 5/24/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DCDodgeballOrientation) {
    
    DCDodgeballOrientationUp    = 0, //ball run up
    DCDodgeballOrientationDown,      //
    DCDodgeballOrientationLeft,      //
    DCDodgeballOrientationRight
};

@interface DCGameView : UIView

@property (nonatomic, assign) CGPoint dodgeBallPoint;
@property (nonatomic, assign) NSInteger score;

- (void)setDCGameView:(UIView *)superView;

//手势移动白球
- (void)dodgeballMoveWithPan:(DCDodgeballOrientation)orien panPoint:(CGPoint)point getAimball:(void(^)(BOOL isGetted))aimblock;

//障碍球移动判断是否碰到球
- (BOOL)runningBalltoDetermintoHit:(UIImageView *)bigBall;

- (void)removePreyballAnimation;

- (void)addAnimationforPreyView;

@end

NS_ASSUME_NONNULL_END
