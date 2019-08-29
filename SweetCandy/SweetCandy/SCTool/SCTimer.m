//
//  SCTimer.m
//  SweetCandy
//
//  Created by HC16 on 6/5/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCTimer.h"

@implementation SCTimer
{
    NSTimer *_timer;
    NSString *_timerStr;
}
+ (SCTimer *)defaultTimer {
    
    static SCTimer *_sctimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sctimer = [[SCTimer alloc] init];
    });
    
    return _sctimer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self timerInit];
    }
    return self;
}

static int _totalSec = 0;
- (void)timerInit {
    
    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRunning) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerRunning {
    
    _totalSec++;
    if (_totalSec < 60) {
        
        if (_totalSec < 10) {
            _timerStr = [NSString stringWithFormat:@"00:0%d", _totalSec];
        } else {
            
            _timerStr = [NSString stringWithFormat:@"00:%d", _totalSec];
        }
    } else {
        
        int min = _totalSec/60;
        int sec = _totalSec%60;
        
        if (min < 10) {
            _timerStr = [NSString stringWithFormat:@"0%d:%d", min, sec];
            
            if (sec < 10) {
                _timerStr = [NSString stringWithFormat:@"0%d:0%d", min, sec];
            }
        } else {
            
            _timerStr = [NSString stringWithFormat:@"%d:%d", min, sec];
            
            if (sec < 10) {
                _timerStr = [NSString stringWithFormat:@"%d:0%d", min, sec];
            }
        }
    }
    
    if (self.timerGone) {
        self.timerGone(_timerStr);
    }
}

- (void)timerStart {
    
    _totalSec = 0;

    
    if (_timer) {
        [self timerRunning];
        [_timer fire];
    } else {
        
        [self timerInit];
        [_timer fire];
    }
}

- (void)timerStop:(void (^)(int, NSString *))endGame {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        
        if (endGame) {
            endGame(_totalSec, _timerStr);
        }
    }
}

@end
