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
        [self setTimerUI];
//        [self setTimer];
    }
    return self;
}

static int time_i = 0;
- (void)setTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerUI) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

- (void)updateTimerUI {

    time_i++;

    NSString *showTimer;

    if (time_i < 10) {
        
        showTimer = [NSString stringWithFormat:@"00%d", time_i];
    } else if (time_i < 100) {
        
        showTimer = [NSString stringWithFormat:@"0%d", time_i];
    } else {
        
        showTimer = [NSString stringWithFormat:@"%d", time_i];
    }
    
    _timerTextLabel.text = showTimer;
}

- (void)setTimerUI {
    
    self.frame = CGRectMake(0, 0, 80, 44);

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.frame];
    [imgV setImage:[UIImage imageNamed:@"btn_time"]];
    [self addSubview:imgV];
    
    _timerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    _timerTextLabel.backgroundColor = [UIColor whiteColor];
    _timerTextLabel.textColor = [UIColor whiteColor];
    _timerTextLabel.textAlignment = NSTextAlignmentCenter;
    _timerTextLabel.font = [UIFont boldSystemFontOfSize:20];
    _timerTextLabel.text = @"000";
//    time_i = self.
    
    
//    _timerTextLabel.layer.cornerRadius = 5;
//    _timerTextLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _timerTextLabel.layer.borderWidth = 0.8;
    
    _timerTextLabel.center = self.center;
    [self addSubview:_timerTextLabel];
    
}

- (void)timerStart {
    
    time_i = 0;
    
    if (_timer != nil) {
        
        NSLog(@"timer stop!!!");
        [self timerStop];
    }
    
//    _timerTextLabel.text = @"000";
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

- (void)clearTimer {
    
     _timerTextLabel.text = @"000";
}

- (void)dealloc {
  
    [_timer invalidate];
    _timer = nil;
}

@end
