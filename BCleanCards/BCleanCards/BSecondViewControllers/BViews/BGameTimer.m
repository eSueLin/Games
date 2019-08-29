//
//  BGameTimer.m
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BGameTimer.h"

@implementation BGameTimer

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

{
    NSTimer *_timer;
    UILabel * _timerLabel;
}


- (instancetype)initWithTotalTime:(int)totalTime
{
    self = [super init];
    if (self) {
        self.totalTime = totalTime;
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
    
    self.frame = CGRectMake(0, 0, 44, 44);
    self.backgroundColor = [UIColor clearColor];
    
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.textAlignment = NSTextAlignmentLeft;
    _timerLabel.font = [UIFont boldSystemFontOfSize:15];

    time_i = self.totalTime;
    [self updateTimerUI];
    
    _timerLabel.center = self.center;
    [self addSubview:_timerLabel];
}


- (void)updateTimerUI {
    
    NSString *showTimer;

    showTimer = [NSString stringWithFormat:@"%ds", time_i];

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

- (void)addTime:(int)time {
    
    time_i += time;
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
