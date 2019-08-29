//
//  DCVoiceSettingView.m
//  DodgeCombat
//
//  Created by HC16 on 6/11/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCVoiceSettingView.h"
#import "../Catogary/CatogaryHeader.h"
#import "../DCRules/DCRulesHeader.h"

@interface DCVoiceSettingView()<UIGestureRecognizerDelegate>

@end
@implementation DCVoiceSettingView
{
    
    __weak IBOutlet UIImageView *voiceBottomImageView;
    __weak IBOutlet UIImageView *voiceprocessControl;
    __weak IBOutlet UIImageView *voiceproccess;
    __weak IBOutlet UIView *shawdowView;
    __weak IBOutlet UIImageView *settingframework;
    
    CGFloat firstX;
    CGFloat firstY;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self volumnControl];
    
}

- (void)volumnControl {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [voiceprocessControl addGestureRecognizer:pan];
    voiceprocessControl.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [shawdowView addGestureRecognizer:tap];
    
    [self performSelector:@selector(latertoResetView) withObject:nil afterDelay:0.01];

    [BYSystemVolum sharedVolum].systemVolumChanging = ^(float volum) {
        
        self->voiceproccess.width = self->voiceBottomImageView.width*volum;
        self->voiceprocessControl.centerX = self->voiceproccess.right;

        
        if (self.volumChanging) {
            self.volumChanging(volum);
        }
    };
    
}

- (void)latertoResetView {
    
    //获取系统音量大小，设置view
    float systemVolum = [BYSystemVolum getSystemVolum];
    voiceproccess.width = systemVolum*voiceBottomImageView.width;
    voiceprocessControl.centerX = voiceproccess.right;
    //    NSLog(@"systemVolum:%f", systemVolum);
}

- (void)pan:(UIGestureRecognizer *)ges {
    
    CGPoint transPoint = [(UIPanGestureRecognizer *)ges translationInView:self];
    if (fabs(transPoint.y)>voiceprocessControl.height/2) {
        return;
    }
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        firstX = voiceprocessControl.centerX;
    }
    
    CGFloat moveCenterX = firstX + transPoint.x;
    if ((moveCenterX-voiceproccess.left)>=0 && (moveCenterX-voiceproccess.left) <= voiceBottomImageView.width) {
        
        voiceprocessControl.centerX = moveCenterX;
        voiceproccess.width = moveCenterX-voiceproccess.left;
        
        float volum= (float)voiceproccess.width/(float)voiceBottomImageView.width;
//        if (volum < 0.1) {
//            
//            volum = 0;
//        }
        
        if (self.volumChanging) {
            [BYSystemVolum setSystemVolum:volum];
            self.volumChanging(volum);
        }
    }
    
}

- (void)tap:(UIGestureRecognizer *)ges {
    
    [self removeFromSuperview];
    //通知游戏开始
    if (self.closeSettingView) {
        self.closeSettingView();
    }
}

#pragma mark - delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint locatPoint = [touch locationInView:self];
    if (locatPoint.x > settingframework.left && locatPoint.x < settingframework.right && locatPoint.y > settingframework.top && locatPoint.y < settingframework.bottom) {
        return NO;
    }
    return YES;
}


@end
