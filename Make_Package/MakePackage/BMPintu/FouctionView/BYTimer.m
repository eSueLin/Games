//
//  BYTimer.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BYTimer.h"
#import "BYGameCenterInt.h"

@implementation BYTimer
{
    
    NSTimer * _timer;
    UILabel * _timerTextLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

static int time_i = 0;
- (void)setTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerUI) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)setCountdownTime:(int)countdownTime {
    
    _countdownTime = countdownTime;
    time_i = countdownTime;
}

- (void)updateTimerUI {


    NSString *showTimer;
    
    showTimer = [NSString stringWithFormat:@"%d", time_i];
    
    if (self.tblock) {
        self.tblock(time_i);
    }
    
    if (time_i == 0) {
        
        [self timerStop];
    }
    
    time_i--;

}


- (void)timerStart {
    
    time_i = self.countdownTime;
    
    if (_timer != nil) {
        
        NSLog(@"timer stop!!!");
        [self timerStop];
    }
    
    [self setTimer];
    [_timer fire];
}

//销毁定时器
- (void)timerStop {
    
    //停止计时，记录时间, 时间归0
    self.usedTime = time_i;
//
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
  
    [_timer invalidate];
    _timer = nil;
}

@end
