//
//  DCHitBall.m
//  DodgeCombat
//
//  Created by HC16 on 5/26/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCHitBall.h"
#import "../Catogary/UIView+Additions.h"

//#define HITBALLWIDTH
static const CGFloat kHitballWidth = 50;

@implementation DCHitBall

+ (UIImageView *)addHitBall:(UIView *)gameArea screenViewSize:(CGSize)screenSize runningOrien:(nonnull void (^)(DCHitBallOrien, UIImageView * _Nonnull))runingOrien{
  
    UIImageView *ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    ball.size = CGSizeMake(kHitballWidth, kHitballWidth);
    ball.layer.cornerRadius = ball.width/2;
    UIImage *hitImage = [UIImage imageNamed:@"guard"];
    ball.contentMode = UIViewContentModeScaleAspectFit;

    CGPoint gameAreaCenter = gameArea.center;
    NSInteger locRand = arc4random()%3;
    NSInteger rand = arc4random()%4;
  
    CGPoint point;
    float pointx = 0.0;
    float pointy = 0.0;
    CGFloat ballWithS = ball.width/2;
    

    
    DCHitBallOrien hitBallOrien;
    switch (rand) {
        case 0: //from top
        {
            
            float dist = (locRand-1)*((float)gameArea.width/3);
            pointx = gameAreaCenter.x+dist;
            pointy = 0-ballWithS;
            
            hitBallOrien = DCHitBallVerticalDown;
            hitImage = [UIImage imageWithCGImage:hitImage.CGImage scale:hitImage.scale orientation:UIImageOrientationRight];
            
        }
            break;
        case 1: //right
        {
            pointx = screenSize.width+ballWithS;
            pointy = gameAreaCenter.y+(locRand-1)*((CGFloat)gameArea.height/3);
            
            hitBallOrien = DCHitBallAcrossLeft;
            hitImage = [UIImage imageWithCGImage:hitImage.CGImage scale:hitImage.scale orientation:UIImageOrientationUpMirrored];
        }
            break;
        case 2: //bottom
        {
            pointx = gameAreaCenter.x+(locRand-1)*((CGFloat)gameArea.width/3);
            pointy = screenSize.height+ballWithS;
            
            hitBallOrien = DCHitBallVerticalUp;
            hitImage = [UIImage imageWithCGImage:hitImage.CGImage scale:hitImage.scale orientation:UIImageOrientationLeft];
        }
            break;
        case 3:  //left
        {
            pointx = 0-ballWithS;
            pointy = gameAreaCenter.y+(locRand-1)*((CGFloat)gameArea.height/3);
            
            hitBallOrien = DCHitBallAcrossRight;
//            hitImage = [UIImage imageWithCGImage:hitImage.CGImage scale:hitImage.scale  orientation:UIImageOrientationUp];
        }
            break;
        default:
        {
            pointx = gameAreaCenter.x+(locRand-1)*((CGFloat)gameArea.width/3);
            pointy = screenSize.height+ballWithS;
            hitBallOrien = DCHitBallVerticalUp;
            
            hitImage = [UIImage imageWithCGImage:hitImage.CGImage scale:hitImage.scale orientation:UIImageOrientationUp];
        }
            break;
    }
    
    [ball setImage:hitImage];

    point = CGPointMake(pointx, pointy);
    
    ball.center = point;
    
    if (runingOrien) {
        runingOrien(hitBallOrien, ball);
    }
    
    return ball;
}

+ (void)hitBallRunningWithBallsArr:(NSMutableArray *)arr level:(int)level inGameArea:(nonnull UIView *)gameArea willDetermin:(nonnull void (^)(UIImageView * _Nonnull))determinBlock{
    
    
    NSArray *contentArr = arr;
    
//    for (NSArray *contentArr in copyArr) {
    
        DCHitBallOrien orien = [contentArr[1] integerValue];
        CGRect rect = [contentArr[0] frame];
        UIImageView *view = contentArr[0];
    

        if (view.centerX < -kHitballWidth/2 || view.centerY < -kHitballWidth/2 || view.centerX > [UIScreen mainScreen].bounds.size.width+kHitballWidth/2 || view.centerY >[UIScreen mainScreen].bounds.size.height+kHitballWidth/2) {
            
            [view removeFromSuperview];
            NSTimer *timer = arr[2];
            [timer invalidate];
            timer = nil;
            return;
        }
        
        switch (orien) {
            case DCHitBallAcrossRight:
            {
                rect.origin.x += (3 + 0.3*level);
            }
                break;
            case DCHitBallAcrossLeft:
            {
                rect.origin.x -= (3 + 0.3*level);
            }
                break;
            case DCHitBallVerticalDown:
            {
                rect.origin.y += (3 + 0.3*level);
            }
                break;
            case DCHitBallVerticalUp:
            {
                rect.origin.y -= (3 + 0.3*level);
            }
                break;
            default:
                break;
        }
        
        view.frame = rect;
    
    if ((view.bottom >= gameArea.top && view.top <= gameArea.bottom) && (view.right >= gameArea.left && view.left <= gameArea.right)) {
        //区域内判断是否碰到球
        if (determinBlock) {
            determinBlock(view);
        }
        
    }
        
        if (nil == view) {
            
            return;
        }
    
}

@end
