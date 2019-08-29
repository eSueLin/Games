//
//  LYPuzzlePTViewController.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/23.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYPuzzlePTViewController.h"
#import "Tool/Toolbox.h"
#import "LYPuzzlePiecesImage.h"
#import "LYPuzzleCollectionView.h"
#import "Founction/LYPuzzlesReadyView.h"
#import "Founction/LYCountdownTimer.h"
#import "LYPassGameView.h"
#import "LYGameOverView.h"
#import "LYDataMes/LYDataMesta.h"

@interface LYPuzzlePTViewController ()<LYPuzzlePiecesImageDelegate, LYCountdownTimerDelegate, LYGameResultDelegate>

@property (nonatomic, strong) LYPuzzleCollectionView *puzzlesCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;

@end

@implementation LYPuzzlePTViewController
{
    LYPuzzlePiecesImage *_puzzles;
    UIImageView *_tipImgView;
    BYShadowBGView *_bgView;
    LYCountdownTimer *_timer;
    __weak IBOutlet UILabel *timeL;
    
    NSString *_puzzleImageName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.timerLabel removeFromSuperview];
    [self setBeginningView];
}

- (void)viewDidAppear:(BOOL)animated {
   
    [super viewDidAppear:animated];
    [self setTimerView];
 
}

- (IBAction)showTip:(id)sender {

    [_tipImgView setImage:[UIImage imageNamed:_puzzleImageName]];
    [_tipImgView setAlpha:0.5];
}

- (IBAction)hideTip:(id)sender {
    
    [_tipImgView setImage:nil];
    [_tipImgView setAlpha:1];
}
//退出游戏
/**
 *  1.停止计时，重置时间
 *  2.返回上一层游戏
 **/
- (IBAction)gameExit:(id)sender {

    [_timer turnDownTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setBeginningView {
    
    _puzzleImageName = [self getImageNameInRandom];
    
    LYPuzzlesReadyView *readyView = [[LYPuzzlesReadyView alloc] initWithImageName:_puzzleImageName];
    
    readyView.gameStart = ^{
        
        [self->_timer  turnOnTimer];
    };
    
    [self.view addSubview:readyView];
}

- (void)setTimerView {
    
    _timer = [[LYCountdownTimer alloc] initWithTotalTime:self.levelTotalTime withLayoutLabel:self.timerLabel];
    _timer.center = self.timerLabel.center;
    [self.timerLabel setAlpha:0];
    _timer.delegate = self;
    
    UIView *firstView = [[self.view subviews] lastObject];
    [self.view addSubview:_timer];
    [self setMainUI];

    [self.view bringSubviewToFront:firstView];
    

}

- (void)setMainUI {
    
    _tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20)];
//    _tipImgView.top = _timer.top+_timer.height+10;
    
    CGFloat puzzleWith = _tipImgView.height/6;
    _tipImgView.size = CGSizeMake(puzzleWith*4, puzzleWith*4);
    _tipImgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);


    _tipImgView.top = _timerLabel.bottom + 20;
    
    _tipImgView.layer.borderColor = [UIColor blackColor].CGColor;
    _tipImgView.layer.borderWidth = 1;
    
    [self.view addSubview:_tipImgView];
    
    [self createPuzzles];
}

- (NSString *)getImageNameInRandom {
    
    NSString *imgName;
    
    int rangNum = random()%6;
    
    NSLog(@">>>%i", rangNum);
    
    imgName = [NSString stringWithFormat:@"pic_0%i", rangNum+1];
    
    return imgName;
}

- (void)createPuzzles {
    
    
    _puzzles = [[LYPuzzlePiecesImage alloc] initPuzzlePiecesWithImage:_puzzleImageName tipsView:_tipImgView];
    _puzzles.delegate = self;
    _puzzles.pieceLevel = self.gameLevel;
    [_puzzles startSliceWithSuperView:self.view];
    
    [self setCollectionViewWithTipImageView:_tipImgView];
    
}

- (void)setCollectionViewWithTipImageView:(UIImageView *)imgV {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.puzzlesCollectionView = [[LYPuzzleCollectionView alloc] initWithFrame:CGRectMake(0, imgV.bottom+10, [UIScreen mainScreen].bounds.size.width, imgV.width/self.gameLevel * 3/2) collectionViewLayout:flowLayout];
    [self.puzzlesCollectionView puzzleCollectionViewInitData];
    [self.puzzlesCollectionView loadDataWithDataSource:_puzzles.pieceImageViewsArray];

    [self.view addSubview:self.puzzlesCollectionView];
}

#pragma mark - puzzlePiecesImage delegate
- (void)puzzleImagesGestureReconizeDelegateRespondWithGesture:(UIGestureRecognizer *)gestureRecognizer receiveTouch:(UITouch *)touch {
    
    if ([[[touch.view superview] superview] isKindOfClass:[UICollectionViewCell class]] && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        if (0 == self.puzzlesCollectionView.dataSourceArray.count) {
            return;
        }
        
        UIImageView *touchImgV = (UIImageView*)touch.view;
        
        //通过获取cell的contentview确认对应在collectionView上的坐标，确定cell的indexPath
        CGPoint indexPoint = [[touchImgV superview] convertPoint:CGPointZero toView:self.puzzlesCollectionView];
        NSLog(@">>>%f,%F", indexPoint.x, indexPoint.y);
        NSIndexPath *indexPath = [self.puzzlesCollectionView indexPathForItemAtPoint:indexPoint];
        
        
        [self.puzzlesCollectionView.dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.puzzlesCollectionView  removeDataforCell:indexPath];
        
        CGPoint locationPoint = [touch locationInView:self.view];
        touchImgV.center = locationPoint;
        [touchImgV removeFromSuperview];
        [self.view addSubview:touchImgV];
        [self.view bringSubviewToFront:touchImgV];
    }
}

//完成拼图回调
- (void)puzzleImagesMovetoTargetFrameFinishedWithObject:(id)object {

    [_timer turnDownTimer];
    
    LYPassGameView *passView = [[[NSBundle mainBundle] loadNibNamed:@"LYPassGameView" owner:nil options:nil] firstObject];
    passView.delegate = self;
    passView.frame = self.view.frame;
    [self.view addSubview:passView];
    
    //新的关卡破解，存入数据库
    [[LYDataMesta sharedInstance] dataUpdateWithStage:self.chosenStage];
}

#pragma mark - timer delegate
- (void)countdownTimerbeRunofTime {
    
    LYGameOverView *goView = [[[NSBundle mainBundle] loadNibNamed:@"LYGameOverView" owner:nil options:nil] firstObject];
    goView.frame = self.view.frame;
    goView.delegate = self;
    
    [self.view addSubview:goView];
}


#pragma mark - game result delegate
- (void)resulttoExitGame {
    
    [self gameExit:nil];
}

//重新开始
- (void)resulttoReplayGame:(id)sender {
    
//    [_timer turnDownTimer];
  
    
//    [self.puzzlesCollectionView ]
//    [self.puzzlesCollectionView loadDataWithDataSource:_puzzles.pieceImageViewsArray];
    [(UIView *)sender removeFromSuperview];
    [self clearViewstoRestartGame];
    
    [self setTimerView];
    [_timer turnOnTimer];
}

//玩上一关
- (void)resultFailedtoPlayLastLevelGame:(id)sender {
    
    //获取上一关卡游戏时间
    [_timer turnDownTimer];
    [(UIView *)sender removeFromSuperview];
}

//玩下一关
- (void)resulttoPlayNextLevelGame:(id)sender {
    
    //获取下一关卡游戏。。
    [_timer turnDownTimer];
    [(UIView *)sender removeFromSuperview];
    [self clearViewstoRestartGame];

    _puzzleImageName = [self getImageNameInRandom];

    //重新加载下一关游戏
    //选择下一关
    self.chosenStage++;
//    NSArray *stagesArr = [[LYDataMesta sharedInstance] getLevelsWithPassed];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LevelTime" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSDictionary *tagDic = [plistDict valueForKey:[NSString stringWithFormat:@"%ld", self.chosenStage]];
    NSInteger level = [tagDic[@"level"] integerValue];
    int time = [tagDic[@"time"] intValue];
    self.levelTotalTime = time;
    self.gameLevel = level;
//    self.chosenStage = [stagesArr.lastObject integerValue];
    
    [self setTimerView];
    [_timer turnOnTimer];
}


- (void)clearViewstoRestartGame {

    [_puzzles resetData];

    [_puzzlesCollectionView removeFromSuperview];
    [_timer removeFromSuperview];
    [_tipImgView removeFromSuperview];
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
