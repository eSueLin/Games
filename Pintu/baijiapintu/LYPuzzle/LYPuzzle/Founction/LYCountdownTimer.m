//
//  LYCountdownTimer.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/24.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYCountdownTimer.h"
#import "../Tool/Toolbox.h"

@implementation LYCountdownTimer
{
    NSTimer *_timer;
    UILabel * _timerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTotalTime:(int)totalTime withLayoutLabel:(nonnull UILabel *)label
{
    self = [super init];
    if (self) {
        self.totalTime = totalTime;
        self.textLabel = label;
        [self setTimerUI];
    }
    return self;
}

static int time_i = 0;
- (void)setTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)setTimerUI {
    
    self.frame = CGRectMake(0, 0, 80, 44);
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.frame];
    [imgV setImage:[UIImage imageNamed:@"btn_time"]];
    [self addSubview:imgV];
    
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    _timerLabel.textColor = [UIColor redColor];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.font = self.textLabel.font;
//    [UIFont syst]
    time_i = self.totalTime;
    [self updateTimerUI];
    
    _timerLabel.center = self.center;
    [self addSubview:_timerLabel];
}


- (void)updateTimerUI {
    
    //    time_i++;
    
    NSString *showTimer;
    
    if (time_i < 10) {
        
        showTimer = [NSString stringWithFormat:@"00%d", time_i];
    } else if (time_i < 100) {
        
        showTimer = [NSString stringWithFormat:@"0%d", time_i];
    } else {
        
        showTimer = [NSString stringWithFormat:@"%d", time_i];
    }
    
    _timerLabel.text = showTimer;
}

- (void)timerDown {
    
    //时间为0，通知游戏失败
    if (0 == time_i) {
        
        
        //通知游戏失败
        if ([self.delegate respondsToSelector:@selector(countdownTimerbeRunofTime)]) {
            
            [self.delegate countdownTimerbeRunofTime];
        }
        
        [self turnDownTimer];
        return;
    }
    
    time_i--;
    [self updateTimerUI];
}

- (void)turnOnTimer {
    
    if (_timer != nil) {
        
        [self turnDownTimer];
    }
    
    time_i = self.totalTime;
    [self updateTimerUI];
    [self setTimer];
    [_timer fire];
    
}

- (void)turnDownTimer {
    
    [_timer invalidate];
    _timer = nil;
}
@end
