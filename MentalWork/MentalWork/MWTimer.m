//
//  MWTimer.m
//  MentalWork
//
//  Created by HC16 on 5/17/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MWTimer.h"

@implementation MWTimer
{
    NSTimer *_timer;
    NSString *_timerStr;
}
static MWTimer *_mwTimer = nil;
+ (MWTimer *)defaultTimer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mwTimer = [[MWTimer alloc] init];
    });
    
    return _mwTimer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initTimer];
    }
    return self;
}

- (void)initTimer {
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

//开始计时
- (void)timerTurnOn:(NSString *)time {
    
    _timerStr = time;
    if (_timer == nil) {
        [self initTimer];
    }
    [_timer fire];
}

- (void)timeDown {
    
    NSArray *timeArr = [_timerStr componentsSeparatedByString:@":"];
    int min = [timeArr[0] intValue];
    int second = [timeArr[1] intValue];
    
    NSString *timerStr = @"";
    if (second > -1 && min == 0) {
        second--;
        NSString *secStr = [NSString stringWithFormat:@"%i", second];
        if (second < 10) {
            secStr = [NSString stringWithFormat:@"0%i", second];
        }
        timerStr = [NSString stringWithFormat:@"%@:%@", timeArr[0], secStr];
        _timerStr = timerStr;
        
        //通知不能进行游戏
        if (second == 0) {
            
        }
    }
    
    if (second == 0 && min != 0) {
        second = 59;
        min--;
        timerStr = [NSString stringWithFormat:@"0%i:%i", min, second];
        _timerStr = timerStr;
    }
    
    if (second > 0 && min != 0) {
        
        second--;
        if (second < 10) {
            timerStr = [NSString stringWithFormat:@"0%i:0%i", min, second];
        } else {
            timerStr = [NSString stringWithFormat:@"0%i:%i", min, second];
        }
        
        _timerStr = timerStr;
    }
    
    if (second == -1) {
        second--;
    }
    
    if (second == -2 && min == 0) {
        
        _timerStr = @"timesOut";
        timerStr = kMWTimerOverTime;
        [_timer invalidate];
    }
    
    if (self.timing) {
        self.timing(_timerStr);
    }
}

- (void)timerTurnOut {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
