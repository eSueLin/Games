//
//  MentalWorkViewController.m
//  MentalWork
//
//  Created by HC16 on 5/16/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkViewController.h"
#import "UIView+Additions.h"
#import "MWTimer.h"
#import "MentalWorkFailView.h"
#import "MentalWorkCompleteView.h"
#import "MentalWorkBGMusic.h"
#import "MWData.h"
#import "MentalWorkGameAreaView.h"
#import "MWGameDataProcessing.h"
#import "ViewinRootVC/ViewinRootVCHeader.h"

@interface MentalWorkViewController ()<MentalWorkGameResultDelegate, MentalWorkGameAreaViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *LevelImgV;
@property (weak, nonatomic) IBOutlet UIView *gameBottomView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;

@property (strong, nonatomic) NSMutableArray *cardsNameArr;

@property (assign, nonatomic) BOOL isCompleted;

@end

@implementation MentalWorkViewController
{
    int _gameAreaKi;
    int _gameAreaKj;
    int _imagesTotal;  //剩余图片总数
    NSString *_totalTimeStr;
    MentalWorkGameAreaView *_gameAreaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(loadViewAfterNib) withObject:nil afterDelay:0.01];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)loadViewAfterNib {
    
    [self initData];
    [self updateUI];
    [self createGameAreaUI];
    [self performSelector:@selector(beginTiming) withObject:nil afterDelay:1];
    
//    [[MentalWorkBGMusic sharedInstance] turnOnBGM];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[MWTimer defaultTimer] timerTurnOut];  //销毁技术器
//    [[MentalWorkBGMusic sharedInstance] turnOffBGM]; //关闭背景音乐
}

- (IBAction)backBtntoClick:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginTiming {

    __block typeof(self) mwVC = self;
    [MWTimer defaultTimer].timing = ^(NSString * _Nonnull timeStr) {
        mwVC.timeLabel.text = timeStr;
        
        if ([timeStr isEqualToString:@"00:00"]) {
            [mwVC.view setUserInteractionEnabled:NO];
        }
        
        if ([timeStr isEqualToString:@"timesOut"] && !mwVC.isCompleted) {
            //时间到，游戏结束
            mwVC.timeLabel.text = @"00:00";
            [mwVC showFailedtoGameView];
        }
    };
    
    [[MWTimer defaultTimer] timerTurnOn:self.timeLabel.text];
    
}


- (void)initData {

    self.isCompleted = NO;
    _totalTimeStr = [MWGameDataProcessing getGameTimeWithLevel:self.level];

    NSArray *arr = [MWGameDataProcessing getGameAreaTypeFromPlistWithLevel:self.level];
    _gameAreaKi = [arr[0] intValue];
    _gameAreaKj = [arr[1] intValue];
    _imagesTotal = _gameAreaKi*_gameAreaKj;

    self.cardsNameArr = [MWGameDataProcessing createArrayForImagesNameWithVer:_gameAreaKi Hor:_gameAreaKj];
}

- (void)updateUI {
    
    [self.LevelImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LEVEL%i", self.level]]];
    [self.timeLabel setText:_totalTimeStr];
}

- (void)createGameAreaUI {
    
    if (_gameAreaView) {
        [_gameAreaView removeFromSuperview];
        _gameAreaView = nil;
    }
    
    _gameAreaView = [[MentalWorkGameAreaView alloc] initWithGameArearView:self.gameBottomView level:self.level imageNames:self.cardsNameArr];
    _gameAreaView.delegate = self;
    
    [self.view addSubview:_gameAreaView];
    //get the game model like:@[@"2", @"3"], mean:2x3
    [_gameAreaView createGameAreaWithVer:_gameAreaKi hor:_gameAreaKj];
}


#pragma mark -
#pragma mark - gameArea delegate
- (void)mwGameAreaCompleted {
    
    self.isCompleted = YES;
    //show complete View
    [self showCompletedView];
    if ([self.delegate respondsToSelector:@selector(mentalWorkGameOvertoUpdateUIWithLevel:)]) {
        
        //解锁新的关卡
        [self.delegate mentalWorkGameOvertoUpdateUIWithLevel:self.level+1];
    }
}

- (void)mwGameAreaCleaning {
    
    self.ScoreLabel.text = [NSString stringWithFormat:@"%ld", self.ScoreLabel.text.integerValue+5];
}

#pragma mark -
#pragma mark - game over tip view
- (void)showCompletedView {
    
    MentalWorkCompleteView *comView = [self getNibsArrWothNibName:@"MentalWorkCompleteView"];
    comView.frame = self.view.frame;
    comView.delegate = self;
    
    [self.view.window addSubview:comView];
}

- (void)showFailedtoGameView {
    
    MentalWorkFailView *failedView = [self getNibsArrWothNibName:@"MentalWorkFailView"];
    failedView.frame = self.view.frame;
    failedView.delegate = self;
    
    [self.view.window addSubview:failedView];
}

- (id)getNibsArrWothNibName:(NSString *)nibName {
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    return [nibArr firstObject];
}

#pragma mark - delegate
- (void)mentalWorktoRestartGame {
    
    [self rebuildView];
}

- (void)mentalWorktoNextGame {
    
    if (6 == self.level) {
        [self mentalWorktoBackHome];
        return;
    }

    self.level ++;
    [self rebuildView];
}

- (void)mentalWorktoBackHome {
    
    [[MWTimer defaultTimer] timerTurnOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rebuildView {
    
    self.view.userInteractionEnabled = YES;
    self.ScoreLabel.text = @"0";
    [[MWTimer defaultTimer] timerTurnOut];
    
    [self initData];
    [self createGameAreaUI];
    [self updateUI];

    [self performSelector:@selector(retiming) withObject:nil afterDelay:0.4];

}

- (void)retiming {
    
    [[MWTimer defaultTimer] timerTurnOn:_totalTimeStr];
}

#pragma mark -
#pragma mark - functions
- (NSString *)formartStringWithString1:(NSString *)str1{
    
    return [NSString stringWithFormat:str1,self.level];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
