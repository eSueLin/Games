//
//  HLBaseViewController.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/26.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLBaseViewController.h"
#import "HLTool/HLToolbox.h"
#import "HLResultView.h"
#import "HLCGSuccessView.h"

#define ScreenWith [UIScreen mainScreen].bounds.size.width

@interface HLBaseViewController ()<HLCheckerRulesDelegate, HLResultDelegate>

@end

@implementation HLBaseViewController
{
    UIImageView *_numImgV1;
    UIImageView *_numImgV2;
    HLCheckersRules *_checkerRules;
    NSString * _levelImageName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatCommonView];
    [self enterGame];
}

- (void)creatCommonView {
    
    UIImageView *bottomImgV = [[[UIImageView alloc] init] normalWithFrame:[UIScreen mainScreen].bounds ImageName:@"bc" tag:100];
    
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (statusBarHeight == 44) {
        
        bottomImgV.image = [UIImage imageNamed:@"bg_iphonex"];
    }
    [self.view addSubview:bottomImgV];
    
    UIButton *homebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homebtn setFrame:CGRectMake(20, statusBarHeight, 44, 44)];
    [homebtn setImage:[UIImage imageNamed:@"主页"] forState:UIControlStateNormal];
    [homebtn addTarget:self action:@selector(backtoHomeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homebtn];
    
    UIImageView *recordImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"剩余图钉"]];
    recordImgV.frame = CGRectMake(0, statusBarHeight+5, 180, 35);
    recordImgV.centerX = self.view.centerX;
    [self.view addSubview:recordImgV];
    
    _numImgV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    _numImgV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2"]];
    
    _numImgV1.frame = CGRectMake(recordImgV.centerX+recordImgV.width/4-18, recordImgV.top+8, 14, 20);
    _numImgV2.frame = _numImgV1.frame;
    _numImgV2.left = _numImgV1.right;
    _numImgV1.contentMode = UIViewContentModeScaleAspectFit;
    _numImgV2.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_numImgV1];
    [self.view addSubview:_numImgV2];
    
    UIButton *backStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backStepBtn setFrame:CGRectMake(self.view.width-64, statusBarHeight, 44, 44)];
    [backStepBtn setImage:[UIImage imageNamed:@"撤回"] forState:UIControlStateNormal];
    [backStepBtn addTarget:self action:@selector(backtoLastStep) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backStepBtn];
}

//返回首页
- (void)backtoHomeView {
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backtoLastStep {
    
    [_checkerRules backtoLastStep];
}
//

- (void)createGameView {
    
}

- (void)enterGame {
    
    NSInteger count = 0;
    NSArray *chessmansArr = @[@"棋子粉", @"小黄棋子", @"白色棋子", @"绿棋", @"蓝色棋子", @"小黄棋子"];
    _levelImageName = chessmansArr[self.gameLevel];
    
    switch (self.gameLevel) {
        case GameLevelTypeFirst:
        {
            HLPinkCheckerView *pinkView = [[HLPinkCheckerView alloc] init];
            pinkView.center = self.view.center;
            [pinkView setImageViewforCheckerboard];
            pinkView.centerY = self.view.centerY + 20;
            pinkView.rules.delegate = self;
            [self.view addSubview:pinkView];
//            pinkView.tag = 200;

            count = pinkView.rules.chessmenMutaArray.count;
            _checkerRules = pinkView.rules;
    
        }
            break;
        case GameLevelTypeSecond:
        {
            HLYellowCheckerView *yellowView = [[HLYellowCheckerView alloc] init];
            yellowView.center = self.view.center;
            [yellowView setImageViewforCheckerboard];
            yellowView.centerY = self.view.centerY + yellowView.checkerFallenSize.width;
            yellowView.rules.delegate = self;
            [self.view addSubview:yellowView];
//            yellowView
            
            count = yellowView.rules.chessmenMutaArray.count;
            _checkerRules = yellowView.rules;
    
        }
            break;
        case GameLevelTypeThird:
        {
            HLWhiteCheckerView *whiteView = [[HLWhiteCheckerView alloc] init];
            whiteView.center = self.view.center;
            [whiteView setImageViewforCheckerboard];
            whiteView.centerY =  self.view.centerY + whiteView.checkerFallenSize.width;
            whiteView.rules.delegate = self;
            [self.view addSubview:whiteView];
            
            _checkerRules = whiteView.rules;
            count = whiteView.rules.chessmenMutaArray.count;
        }
            break;
        case GameLevelTypeForth:
        {
            HLGreenCheckerView *chessPlateformView = [[HLGreenCheckerView alloc] init];
            chessPlateformView.isHomePage = NO;
            [chessPlateformView setImageViewforCheckerboard];
            chessPlateformView.center = self.view.center;
            chessPlateformView.centerY = self.view.centerY + (chessPlateformView.width - 8)/8/4;
            chessPlateformView.rules.delegate = self;
            
            [self.view addSubview:chessPlateformView];
            
            _checkerRules = chessPlateformView.rules;
            count = chessPlateformView.rules.chessmenMutaArray.count;
        }
            break;
        case GameLevelTypeFifth:
        {
            HLBlueCheckerView *blueView = [[HLBlueCheckerView alloc] init];
            blueView.center = self.view.center;
            [blueView setImageViewforCheckerboard];
            blueView.centerY = self.view.centerY;
            blueView.rules.delegate = self;
            [self.view addSubview:blueView];
            
            _checkerRules = blueView.rules;
            count = blueView.rules.chessmenMutaArray.count;
        }
            break;
        case GameLevelTypeSixth:
        {
            HLOrangeCheckerView *org = [[HLOrangeCheckerView alloc] init];
            org.center = self.view.center;
            [org setImageViewforCheckerboard];
            org.centerY = self.view.centerY+org.checkerFallenSize.width;
            org.rules.delegate = self;
            
            [self.view addSubview:org];
            _checkerRules = org.rules;
            count = org.rules.chessmenMutaArray.count;
        }
            break;
        default:
            break;
    }
    
    _checkerRules.viewModel = HLGameViewModelSquare;
    if (self.gameLevel == GameLevelTypeFirst || self.gameLevel == GameLevelTypeFifth || self.gameLevel == GameLevelTypeSixth) {
        
        _checkerRules.viewModel = HLGameViewModelTriangle;
    }
    
    [self showRestChessman:count];
}

- (void)showRestChessman:(NSInteger)count {
    
    [_numImgV1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", count/10]]];
    [_numImgV2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", count%10]]];
}

//剩余数量
- (void)checkerRulesRemoveChessmanWithRest:(NSInteger)count {
    
    [self showRestChessman:count];
}

//通知游戏结束
- (void)checkerRulesGameOver {
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"HLResultView" owner:nil options:nil];
    HLResultView *resultView = [viewArray firstObject];
    resultView.width = [UIScreen mainScreen].bounds.size.width;
    resultView.center = self.view.center;

    [resultView refreshViewWithImageName:_levelImageName countNum:[NSString stringWithFormat:@"%ld", _checkerRules.chessmenMutaArray.count]];
    resultView.delegate = self;
    [self.view addSubview:resultView];
}

//闯关成功
- (void)checkerRulesGameSuceessful {
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"HLCGSuccessView" owner:nil options:nil];
    HLCGSuccessView *successView = [viewArray firstObject];
    successView.delegate = self;
    successView.width = [UIScreen mainScreen].bounds.size.width;
    successView.center = self.view.center;
    [self.view addSubview:successView];
    if (self.gameLevel == GameLevelTypeSixth) {
        return;
    
    }
    
    [[LHGamePass sharedInstance] newGamePassWithLebelType:self.gameLevel+1];
    if (self.statusChange) {
        self.statusChange();
    }
}

- (void)resultViewtoBackHomeView {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resultViewtoRestartGame {
    
    //重新开始游戏
    _checkerRules = nil;
    
    HLCheckersView *view = [self.view viewWithTag:11];
    [view removeFromSuperview];
    
    [self enterGame];
}

- (void)resultViewtoEnterNextGame {
    
    if (self.gameLevel == GameLevelTypeSixth) {
        //最后一关 敬请期待。。
        return;
    }
    HLCheckersView *view = [self.view viewWithTag:11];
    [view removeFromSuperview];
    self.gameLevel = self.gameLevel+1;
    
    [self enterGame];
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
