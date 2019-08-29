//
//  SCGameViewController.m
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCGameViewController.h"
#import "../SCSubViews/SCGameAreaViews/SCGameAreaView.h"
#import "../SCSubViews/SCBasicShadowView/SCBasicShadowView.h"

@interface SCGameViewController ()<HLCheckerRulesDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //record time

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *gameAreaImageView;

@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;

@end

@implementation SCGameViewController
{
    SCBasicShadowView *_tipView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self refreshUI];
    [self performSelector:@selector(refreshUI) withObject:nil afterDelay:0.01];
}

- (void)refreshUI {
    
    [self.labelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"L%ld", self.level]]];
    
    [[SCGameAreaView shareInstance] removeCurrentView];
    __block typeof(self) scVC = self;
    [SCGameAreaView shareInstance].delegate = self;
    [[SCGameAreaView shareInstance] getStageWithLevel:self.level gameAreaBottomView:_gameAreaImageView left:^(int leftCount) {
       
         scVC.leftLabel.text = [NSString stringWithFormat:@"%i", leftCount];
    }];

    _tipView = [[SCBasicShadowView alloc] init];
    
    [SCTimer defaultTimer].timerGone = ^(NSString * _Nonnull timeUp) {
      
        self.timeLabel.text = timeUp;
    };
    
    [[SCTimer defaultTimer] timerStart];

}

- (IBAction)backtoHomeView:(id)sender {

    [[SCTimer defaultTimer] timerStop:^(int usedtime, NSString * _Nonnull timerStr) {
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)restartGame:(id)sender {
    
    [[SCTimer defaultTimer] timerStop:^(int usedtime, NSString * _Nonnull timerStr) {
        
    }];
    
    [self refreshUI];
}

#pragma mark -
#pragma mark - delegate
- (void)checkerRulesRemoveChessmanWithRest:(NSInteger)count {
    
    self.leftLabel.text = [NSString stringWithFormat:@"%ld", count];
}

- (void)checkerRulesGameOver {
    
    NSLog(@">>>game over");
    _tipView = nil;
    _tipView  = [[SCBasicShadowView alloc] init];
    _tipView.currentLevel = self.level;
    
    __block typeof(self) gameVC = self;
    _tipView.shadowViewRespone = ^(BOOL isbackhome) {
      
        if (isbackhome) {
            [gameVC dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [gameVC refreshUI];
        }
    };
    [_tipView showTipView:SCTipViewTypeFail];
    
    [self.view addSubview:_tipView];
    
    [[SCTimer defaultTimer] timerStop:^(int usedtime, NSString * _Nonnull timerStr) {
        
    }];
}

- (void)checkerRulesGameSuceessful {
    
    NSLog(@">>>bingo");
    
    
    _tipView = nil;
    _tipView = [[SCBasicShadowView alloc] init];
    _tipView.currentLevel = self.level;
    
    __block typeof(self) gameVC = self;
    _tipView.shadowViewRespone = ^(BOOL isbackhome) {
     
        if (isbackhome) {
            
            [gameVC dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            if (gameVC.level == 6) {
                
                [gameVC dismissViewControllerAnimated:YES completion:nil];
                return ;
            }
            //play next game;
            gameVC.level++;
            [gameVC refreshUI];
            if ([gameVC.delegate respondsToSelector:@selector(gameViewtoRefreshHomeView:)]) {
                
                [gameVC.delegate gameViewtoRefreshHomeView:(int)gameVC.level];
            }
        }
    };
    
    [_tipView showTipView:SCTipViewTypePass];
    [self.view addSubview:_tipView];
    
    //时间停止, 游戏结束
    [[SCTimer defaultTimer] timerStop:^(int usedtime, NSString * _Nonnull timerStr) {
        
        //存储时间
        //对比最佳时间
        //展示
        NSArray *arr = [[SCTimerUsedStore defaultTimerUserd] getBestScoreWithStage:(int)gameVC.level];
        
        [gameVC->_tipView showPassTime:timerStr historyBest:arr[2]];
        
        [[SCTimerUsedStore defaultTimerUserd] saveStage:(int)gameVC.level usedTime:(int)usedtime timeString:timerStr];
        
    }];
    
}

- (void)saveTime:(int)usedTime timerStr:(NSString *)timerStr{
    
    
    
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
