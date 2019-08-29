//
//  MentalWorkSettingView.m
//  MentalWork
//
//  Created by HC16 on 5/21/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkSettingView.h"
#import "../UIView+Additions.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "../BYSystemVolum.h"

@interface MentalWorkSettingView()<UIGestureRecognizerDelegate>

@end

@implementation MentalWorkSettingView
{
    
    __weak IBOutlet UIImageView *slipballImgV;
    __weak IBOutlet UIImageView *processView;
    __weak IBOutlet UIView *processBtmView;
    
    __weak IBOutlet UIView *shadowView;
    __weak IBOutlet UIImageView *frameSetImgV;
    
    float firstX;
    float firstY;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    pan.delegate = self;
    [slipballImgV addGestureRecognizer:pan];
    slipballImgV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [shadowView addGestureRecognizer:tap];
    
    [self performSelector:@selector(latertoResetView) withObject:nil afterDelay:0.001];
    
//    [self latertoResetView];
//    [self addSubview:[BYSystemVolum getSystemVolumeSlider]];
    
    [BYSystemVolum sharedVolum].systemVolumChanging = ^(float volum) {
      
        self->slipballImgV.centerX = self->processBtmView.width*volum;
        self->processView.width = self->slipballImgV.centerX;
        
        if (self.settingVolum) {
            self.settingVolum(volum);
        }
        
    };
    NSLog(@"it gone more time");

}


- (void)latertoResetView {
    
    //获取系统音量大小，设置view
    float systemVolum = [BYSystemVolum getSystemVolum];
    processView.width = systemVolum*processBtmView.width;
    slipballImgV.centerX = processView.width;
//    NSLog(@"systemVolum:%f", systemVolum);
}



-(UISlider*)getSystemVolumSlider{

    static UISlider *volumViewSlider = nil;
    if (volumViewSlider == nil) {
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        for (UIView * newView  in volumeView.subviews) {
            
            if ([[newView.class description] isEqualToString:@"MPVolumeSlider"] ) {
                volumViewSlider = (UISlider *)newView;
                volumViewSlider.center = CGPointMake(-1000, -1000);
                break;
            }
        }
    }
    return volumViewSlider;
}

- (void)pan:(UIGestureRecognizer *)ges {
    
    CGPoint translatePoint = [(UIPanGestureRecognizer *)ges translationInView:self];
    if (fabs(translatePoint.y)  > slipballImgV.height/2) {
        return;
    }
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        firstX = slipballImgV.centerX;
        firstY = slipballImgV.centerY;
    }
    
    translatePoint.y = 0;
    CGPoint moveCenter = CGPointMake(firstX+translatePoint.x, firstY);
    
    
    float aimRight = moveCenter.x;
    if (aimRight>=0 && aimRight <= processBtmView.width) {
        
        slipballImgV.center = moveCenter;
        processView.width = slipballImgV.centerX;
        float volum= (float)processView.width/(float)processBtmView.width;
        if (volum < 0.1) {
            
            volum = 0;
        }
        
        if (self.settingVolum) {
            [BYSystemVolum setSystemVolum:volum];
            self.settingVolum(volum);
        }
        
//        [[NSUserDefaults standardUserDefaults] setFloat:volum forKey:@"kGameBGM"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - gesture
- (void)tap:(UIGestureRecognizer *)ges {
 
//    CGPoint point = ges point
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint location = [touch locationInView:self];
    if (location.x > frameSetImgV.left && location.x < frameSetImgV.right && location.y < frameSetImgV.bottom && location.y> frameSetImgV.top) {
        return NO;
    }
        return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
