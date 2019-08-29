//
//  DCGameViewController.m
//  DodgeCombat
//
//  Created by HC16 on 5/28/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCGameViewController.h"
#import "DCViews/DCViewsHeader.h"
#import "Catogary/CatogaryHeader.h"
#import "DCRules/DCRulesHeader.h"


@interface DCGameViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scorelabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelNumImgV;

@end

@implementation DCGameViewController
{
    DCGameView *gameView;
    NSTimer *runningTimer;
    NSTimer *addTimer;
    NSMutableArray *runningTimersArr;
    
    CGFloat firstX;
    CGFloat firstY;
    
}

static bool _couldReceiveTouch = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self performSelector:@selector(delaytoRreshUI) withObject:nil afterDelay:0.1];
    [self.view addSubview:[BYSystemVolum getSystemVolumeSlider]];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

}

- (void)delaytoRreshUI {
 
    [self refreshUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    runningTimersArr = [NSMutableArray array];
    
    [self addTimerFireWithSec:2];
}

- (void)addTimerFireWithSec:(int)sec {
    
    if (runningTimersArr.count) {
        
        [runningTimersArr removeAllObjects];
    }
    
    addTimer = [NSTimer timerWithTimeInterval:sec target:self selector:@selector(addRunningHitBall) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:addTimer forMode:NSRunLoopCommonModes];
    
    [addTimer fire];
}

// 2s add one ball
static int timeRunCount = 0;
- (void)addRunningHitBall {
    
    __block typeof(self) dcgameVC = self;
    [DCHitBall addHitBall:gameView screenViewSize:self.view.window.size runningOrien:^(DCHitBallOrien orien, UIImageView * _Nonnull ball) {
        
        [dcgameVC setHitBallRunningWayWithOrien:orien hitball:ball];
        
        if (dcgameVC.levelonGame > 1) {
            UIImageView *fanBall = [[DCGameRules defaultGameRules] showHitballsWithLevel:(int)dcgameVC.levelonGame hitball:ball gameAreaView:dcgameVC->gameView orien:orien];
            [dcgameVC setHitBallRunningWayWithOrien:fanBall.tag hitball:fanBall];
        }
    }];

}

- (void)setHitBallRunningWayWithOrien:(DCHitBallOrien)orien hitball:(UIImageView *)ball {
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:ball];
    timeRunCount++;
    ball.tag = 1000+timeRunCount;
    [arr addObject:@(orien)];
    [self.view addSubview:ball];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:(float)1/60 target:self selector:@selector(ballsRunning:) userInfo:arr repeats:YES];
    [arr addObject:timer];
    [runningTimersArr addObject:timer];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
}

- (void)ballsRunning:(NSTimer *)timer {
    
    [DCHitBall hitBallRunningWithBallsArr:timer.userInfo level:(int)self.levelonGame
                               inGameArea:gameView
                             willDetermin:^(UIImageView * _Nonnull runningball) {
                                 
                                 BOOL ishitted = [self->gameView runningBalltoDetermintoHit:runningball];
                                 if (ishitted) {
                                     
                                     _couldReceiveTouch = NO;

                                     NSLog(@"3.it removed timers:%@", [NSDate date]);
                                     //timer stop. remove animation
                                     [self->addTimer invalidate];
                                     self->addTimer = nil;
                                     for (NSTimer *ntimer in self->runningTimersArr) {

                                         if (ntimer != nil) {
                                             [ntimer invalidate];
                                         }
                                     }
                                     
                                     for (int a = 0; a < self->runningTimersArr.count; a++) {
                                         
                                         NSTimer *aTimer = self->runningTimersArr[a];
                                         aTimer = nil;
                                     }
                                     
                                     //延时
                                     //show game over view to restart
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self showGameOverView];
                                     });
                                 }
                                 
                             }];
}

- (void)showGameOverView
{
    DCGameOverView *overView = (DCGameOverView *)([[NSBundle mainBundle] loadNibNamed:@"DCGameOverView" owner:nil options:nil][0]);
    __block typeof(self) gamevc = self;
    overView.eventRespone = ^(BOOL isBackHome) {
        
        if (isBackHome) {
            [gamevc backtoHome:nil];
        } else {
            
            _couldReceiveTouch = YES;
            //restart
            [self pointtoRestartGame];
        }
    };
    
    overView.frame = self.view.frame;
    [overView showScore:self.scorelabel.text.intValue];
    
    //提交分数
    [[BYGameCenterInt gameCenter] reportResultScore:self.scorelabel.text.integerValue leaderBoard:1];
    
    [self.view addSubview:overView];
}

- (void)pointtoRestartGame {
    // remove all view..
    NSArray *arr = self.view.subviews;
    for (UIView *subView in arr) {
        
        if (subView.tag/1000 > 0) {
            
            [subView removeFromSuperview];
        }
    }
    
    //game view detail deal
    [gameView removeAllSubviews];
    [gameView setDCGameView:self.view];
    
    self.scorelabel.text = @"0";
    self.levelonGame = 1;
    [self.levelNumImgV setImage:[UIImage imageNamed:@"lev1"]];
    
    //reset timers
    [self addTimerFireWithSec:2];
}


- (void)refreshUI {
    
    gameView = [[DCGameView alloc] init];
    [gameView setDCGameView:self.view];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    _couldReceiveTouch = YES;
}

#pragma mark --
#pragma mark - gesture
static bool hasRun = NO;
- (void)pan:(UIPanGestureRecognizer *)gesture {
    
    CGPoint point = [(UIPanGestureRecognizer *)gesture translationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        hasRun = NO;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        if (hasRun) {
            return;
        }
        hasRun = YES;
        __block typeof(self) dcgamevc = self;
        [gameView dodgeballMoveWithPan:DCDodgeballOrientationUp panPoint:point getAimball:^(BOOL isGetted) {
            
            if (isGetted) {
                dcgamevc.scorelabel.text = [NSString stringWithFormat:@"%ld", dcgamevc.scorelabel.text.integerValue + 1];
                //进入下一关
                NSInteger newestScore = dcgamevc.scorelabel.text.integerValue;
                dcgamevc->gameView.score = newestScore;
                
                if (0 == newestScore%10) { //10分一关
                    //level +1
                    dcgamevc.levelonGame++;
                    [dcgamevc.levelNumImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lev%ld", dcgamevc.levelonGame]]];
                    [dcgamevc->addTimer invalidate];
                    
//                    NSLog(@">>>>>Current level:%ld", dcgamevc.levelonGame);
                    if (dcgamevc.levelonGame > 4) {
                        [dcgamevc->addTimer invalidate];
                        dcgamevc->addTimer = nil;

                        [dcgamevc resetAddTimertoLevelFour];
                        return ;
                    }
                    [dcgamevc performSelector:@selector(refireAddTimer) withObject:nil afterDelay:3];
                    //切换下一关游戏模式
                                        
                }
            }
        }];
    }

}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (!_couldReceiveTouch) {
        
        return  NO;
    }
    
    return YES;
}


- (void)resetAddTimertoLevelFour {
    
    [self addTimerFireWithSec:1];
}

- (void)refireAddTimer {
    
    if (addTimer) {
        [addTimer invalidate];
        addTimer = nil;
    }
    [self addTimerFireWithSec:2];
}

#pragma mark -
#pragma mark - outlets touch

- (IBAction)backtoHome:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSettingView:(id)sender {

    DCVoiceSettingView *voiceSetting = (DCVoiceSettingView *)[[[NSBundle mainBundle] loadNibNamed:@"DCVoiceSettingView" owner:nil options:nil] firstObject];
    voiceSetting.frame = self.view.frame;
    [self.view addSubview:voiceSetting];
    voiceSetting.volumChanging = ^(float volum) {
        
        [[DCBackgroundMusic defaultMusic] changeBGMVoice:volum];
    };
    
    UIButton *btn = [self.view viewWithTag:300];

//    __block typeof(self) gamevc = self;
    voiceSetting.closeSettingView = ^{
      
        //音量设置界面关闭，继续游戏
        [self starttoPlay:btn];
    };
    
    //暂停游戏
    if (isPlaying) {
        [self starttoPlay:btn];
    }
}


static bool isPlaying = YES;
- (IBAction)starttoPlay:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (isPlaying) {
        
        _couldReceiveTouch = NO;

        [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        //游戏暂停
        [gameView removePreyballAnimation];
        [addTimer setFireDate:[NSDate distantFuture]];
        for (NSTimer *timer in runningTimersArr) {
            [timer setFireDate:[NSDate distantFuture]];
        }
        
        
    } else {
        
        _couldReceiveTouch = YES;
        
        [btn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        //游戏开始
        [gameView addAnimationforPreyView];
        [addTimer setFireDate:[NSDate distantPast]];
        for (NSTimer *timer in runningTimersArr) {
            [timer setFireDate:[NSDate distantPast]];
        }
    }
    
    isPlaying = !isPlaying;
}

@end
