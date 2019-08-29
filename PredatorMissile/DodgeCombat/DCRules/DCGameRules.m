//
//  DCGameRules.m
//  DodgeCombat
//
//  Created by HC16 on 5/29/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCGameRules.h"


@implementation DCGameRules

+ (DCGameRules *)defaultGameRules {
    
    static DCGameRules *_rules = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rules = [[DCGameRules alloc] init];
    });
    
    return _rules;
}

//不同等级
- (UIImageView *)showHitballsWithLevel:(int)level  hitball:(UIImageView *)ball gameAreaView:(UIView *)gameArea orien:(DCHitBallOrien)orien{
    
    UIImageView *secondImgV = [[UIImageView alloc] initWithImage:ball.image];
    secondImgV.frame = ball.frame;
    secondImgV.backgroundColor = ball.backgroundColor;
    secondImgV.layer.cornerRadius = ball.layer.cornerRadius;
    secondImgV.layer.borderWidth = ball.layer.borderWidth;
    secondImgV.contentMode = UIViewContentModeScaleAspectFit;
    
    //中间位置:两球在同一线上，不同方向;
    //两边位置:两球不同方向同时在隔中间位置的另一条边上，
    if (level == 2) {
        
        
        UIImageOrientation imgOrien = orien<=1?UIImageOrientationDown:UIImageOrientationLeft;
        
        switch (orien) {
            case DCHitBallAcrossLeft:
                imgOrien = UIImageOrientationDownMirrored;
                break;
            case DCHitBallAcrossRight:
                imgOrien = UIImageOrientationUpMirrored;
                break;
            case DCHitBallVerticalUp:
                imgOrien = UIImageOrientationRight;
                break;
            case DCHitBallVerticalDown:
                imgOrien = UIImageOrientationLeft;
                break;

        }
        
        UIImage *secondImg = [UIImage imageWithCGImage:ball.image.CGImage scale:ball.image.scale orientation:imgOrien];
        secondImgV.image = secondImg;
        NSLog(@">>>>>secondImg:%@", secondImg);
        
        
        secondImgV = [self rulesInlevelTwoWithFirstball:ball
                                             secondball:secondImgV
                                           gameAreaView:gameArea
                                  firstballRunningOrien:orien];
        //0 1
        //2 3
        secondImgV.tag = orien%2 == 0?orien+1:orien-1;
    }
    
    if (level == 3) {
        
        secondImgV = [self rulesInLevelThreeWithFirstball:ball
                                               secondball:secondImgV
                                                 gameArea:gameArea
                                     firstballRuningOrien:orien];
        secondImgV.tag = orien;
    }
    
    if (level >= 4) {
        
        secondImgV = [self rulesInLevelFourWithFirstball:ball
                                              secondball:secondImgV
                                                gameArea:gameArea
                                   firstballRunningOrien:orien];
        secondImgV.tag = orien;
    }
    
    
    return secondImgV;
}

- (UIImageView *)rulesInlevelTwoWithFirstball:(UIImageView *)firstball secondball:(UIImageView *)secondball gameAreaView:(UIView *)gameArea firstballRunningOrien:(DCHitBallOrien)orien{
    
    //1.中间位置:两球在同一线上，不同方向;
    //2.两边位置:两球不同方向同时在隔中间位置的另一条边上，
    //判断是否在中间位置
    
    //横向走向
    BOOL isAcross = (orien/2 == 0?YES:NO);
    
    CGFloat symmetricalCenterX = [firstball superview].width-firstball.centerX;
    CGFloat symmetricalCenterY = [firstball superview].height-firstball.centerY;
    
    //横向走向：计算对称X点坐标，，Y坐标不发生大的变化
    //纵向走向：对称Y点坐标，，X坐标不发生大变化


    
    //            fanBall.center = CGPointMake(dcgameVC.view.width-ball.centerX, ball.centerY);
    
    
    //            fanBall.center = CGPointMake(ball.centerX, self.view.height-ball.centerY);
          
    
    secondball.centerX = isAcross?symmetricalCenterX:firstball.centerX;
    secondball.centerY = isAcross?firstball.centerY:symmetricalCenterY;
    
    NSLog(@">>>>>%f,%f", firstball.centerX, firstball.centerY);
    NSLog(@">>>>>%f, %f", secondball.centerX, secondball.centerY);
    return secondball;
}

- (UIImageView *)rulesInLevelThreeWithFirstball:(UIImageView *)firstball secondball:(UIImageView *)secondball gameArea:(UIView *)gameArea firstballRuningOrien:(DCHitBallOrien)orien {
    
    BOOL isAcross = (orien/2 == 0?YES:NO);
    
    BOOL isCenterLine = (firstball.centerX == gameArea.centerX?1:0 || firstball.centerY == gameArea.centerY?1:0);
        
    if(isCenterLine) {
        
        int newballLocation = 0;
        int rand = arc4random()%2;
        if (rand == 0) {
            newballLocation = -1;
        } else {
            newballLocation = 1;
        }
        
        CGFloat newballX = firstball.centerX+newballLocation*((CGFloat)gameArea.width/3);
        CGFloat newballY = firstball.centerY+newballLocation*((CGFloat)gameArea.height/3);
        
        secondball.centerX = isAcross?firstball.centerX:newballX;
        secondball.centerY = isAcross?newballY:firstball.centerY;
        
    }else {
        
        secondball.centerX = isAcross?firstball.centerX:gameArea.centerX;
        secondball.centerY = isAcross?gameArea.centerY:firstball.centerY;
    }
    
    return secondball;
}


- (UIImageView *)rulesInLevelFourWithFirstball:(UIImageView *)firstball secondball:(UIImageView *)secondball gameArea:(UIView *)gameArea firstballRunningOrien:(DCHitBallOrien)orien {
    
    BOOL isAcross = (orien/2 == 0?YES:NO);
    BOOL isCenterLine = (firstball.centerX == gameArea.centerX?1:0 || firstball.centerY == gameArea.centerY?1:0);
    
    if (isCenterLine) {
        
        int newballLocation = [self randForCenterLocationball];
        
        CGFloat newballX = firstball.centerX + newballLocation*((CGFloat)gameArea.width/3);
        CGFloat newballY = firstball.centerY + newballLocation*((CGFloat)gameArea.height/3);
        
        secondball.centerX = isAcross?firstball.centerX:newballX;
        secondball.centerY = isAcross?newballY:firstball.centerY;
        
    } else {
        
        secondball.centerX = isAcross?firstball.centerX:firstball.centerX-(firstball.centerX-gameArea.centerX)*2;
        secondball.centerY = isAcross?firstball.centerY-(firstball.centerY-gameArea.centerY)*2:firstball.centerY;
    }
    
    return secondball;
}


- (int)randForCenterLocationball {
    
    int newballLocation = 0;
    int rand = arc4random()%2;
    if (rand == 0) {
        newballLocation = -1;
    } else {
        newballLocation = 1;
    }
    return newballLocation;
}

@end
