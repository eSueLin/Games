//
//  DCGameView.m
//  DodgeCombat
//
//  Created by HC16 on 5/24/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCGameView.h"
#import "../Catogary/UIView+Additions.h"


@interface DCGameView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@end
@implementation DCGameView
{
    UICollectionViewFlowLayout *_centerCollectionViewFl;
    
    NSTimer *_runningTimer;
    
    UIImageView *_dodgeball;
    
    UIImageView *_preyView;
    
    NSInteger _currentIndex; //location of dodge ball
    
    NSInteger _preyIndex;   //location of prey
    
    UICollectionViewCell *_dodgeballCell;
    
    UIImageView *_runningBigBall;
    
    UICollectionView * _collectionView;
    
    UILabel *_showGetScoreLabel;

    UIView * _superView;
    
    BOOL _gameRunning;
}

- (void)setDCGameView:(UIView *)superView {
    
    _centerCollectionViewFl = [[UICollectionViewFlowLayout alloc] init];
    _centerCollectionViewFl.itemSize = CGSizeMake((125-2)/3, (125-2)/3);
    _centerCollectionViewFl.minimumLineSpacing = 1;
    _centerCollectionViewFl.minimumInteritemSpacing = 1;
    
    self.frame = CGRectMake(0, 0, 125, 125);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 125, 125) collectionViewLayout:_centerCollectionViewFl];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setScrollEnabled:NO];
    _collectionView.layer.masksToBounds = YES;
    _collectionView.layer.cornerRadius  = 5;
    _collectionView.layer.borderColor = [UIColor colorWithRed:(CGFloat)118/255 green:(CGFloat)151/255 blue:(CGFloat)174/255 alpha:1].CGColor;
    _collectionView.layer.borderWidth = 0.8;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectCell"];
    self.center = superView.center;
    _collectionView.center = superView.center;
    _collectionView.centerY = superView.centerY;
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_image"]];
    imgV.frame = CGRectMake(0, 0, _collectionView.width, _collectionView.height);
    
    [_collectionView setBackgroundView:imgV];
    [_collectionView setBackgroundColor:[UIColor clearColor]];

    _currentIndex = 4;
    _preyIndex = -1;
    _dodgeball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hunter_ball"]];
    
    [self preyView];
    [superView addSubview:_collectionView];
    _collectionView.tag = 1500;
    
    [self showGetScoreLabel];
    
    addedNum = 0;

}

- (void)showGetScoreLabel {
    
    _showGetScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    _showGetScoreLabel.contentMode = UIViewContentModeCenter;
    _showGetScoreLabel.text = @"+1";
    _showGetScoreLabel.textColor = [UIColor yellowColor];
    _showGetScoreLabel.hidden = YES;
    [_collectionView.superview addSubview:_showGetScoreLabel];
    _showGetScoreLabel.tag = 1501;
}

- (void)showPreyView {
    
    int preyRand = arc4random()%8;
   
    if (preyRand == _currentIndex) {
        [self showPreyView];
        return;
    }
    //随机位置，不能够出现与之前同一个位置
    if (_preyIndex == preyRand) {
        
        [self showPreyView];
        return;
    }
    
    if (9 == addedNum%10) {
        [_preyView setImage:[UIImage imageNamed:@"sweet8"]];

    } else {
        [_preyView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sweet%i", arc4random()%7+1]]];
    }
    
    _preyIndex = preyRand;
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_preyIndex inSection:0]];
    _preyView.center = cell.center;
    
    [self performSelector:@selector(showPreyViewAfterSec) withObject:nil afterDelay:0.2];
}

- (void)showPreyViewAfterSec {
    
    _preyView.hidden = NO;

}

- (void)preyView {
    
    _preyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    NSInteger rand = arc4random()%7;
    [_preyView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sweet%ld", rand+1]]];
    
    //旋转
    [self addAnimationforPreyView];
    
    [_collectionView addSubview: _preyView];
}

- (void)removePreyballAnimation {
    
    [_preyView.layer removeAllAnimations];
   
}

- (void)addAnimationforPreyView {
    
    CABasicAnimation *preyRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    preyRotationAnimation.toValue = @(2*M_PI);
    preyRotationAnimation.repeatCount = MAXFLOAT;
    preyRotationAnimation.duration = 3;
    preyRotationAnimation.removedOnCompletion = NO;
    
    [_preyView.layer addAnimation:preyRotationAnimation forKey:nil];
}


- (BOOL)runningBalltoDetermintoHit:(UIImageView *)bigball{
    
    _runningBigBall = bigball;
    
    float bigBallCenterX = bigball.centerX;
    float bigBallCenterY = bigball.centerY;

    float dodgeBallCenterX = _dodgeball.centerX+self.left;
    float dodgeBallCenterY = _dodgeball.centerY+self.top;

    if (fabs(bigBallCenterX - dodgeBallCenterX) <= (bigball.width/2+_dodgeball.width/2) &&fabs( bigBallCenterY - dodgeBallCenterY) < 1) {
        NSLog(@"1.it stop animate:%@", [NSDate date]);
        [_preyView.layer removeAllAnimations];
        return YES;
    }
    
    if (fabs(bigBallCenterY - dodgeBallCenterY) <= (bigball.height/2 + _dodgeball.height/2) && fabs( bigBallCenterX - dodgeBallCenterX) < 1) {
        NSLog(@"2.it stop animate:%@", [NSDate date]);

        [_preyView.layer removeAllAnimations];
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark - dodge ball move
static int addedNum = 0;
- (void)dodgeballMoveWithPan:(DCDodgeballOrientation)orien panPoint:(CGPoint)point getAimball:(nonnull void (^)(BOOL))aimblock{
    
    NSInteger index = _currentIndex;
    
    CGFloat positionbias;
    if (point.y == 0) {
        
        positionbias = 1;
    } else {
        
        positionbias = fabs(point.x/point.y);

    }
    
    if (point.x < 0 && positionbias >= 1) {
        //左滑
        index -= 1;
        //边界不可滑动
        if (index == -1 || index == 2 || index == 5) {
            return;
        }
        
    } else if(point.x > 0 && positionbias >= 1){
        //右滑
        index += 1;
        if (index == 3 || index == 6 || index == 9) {
            return;
        }
        
    } else if (point.y < 0 && positionbias < 1) {
        //上滑
        index -=3;
        if (index == -1 || index == -2 || index == -3) {
            return;
        }
        
    } else if (point.y > 0 && positionbias < 1){
        //下滑
        index += 3;
        if (index == 9 || index == 10 || index == 11){
            return;
        }
    } else {
        
        return;
    }
    
    
    _currentIndex = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self->_dodgeball.center = cell.center;
    } completion:^(BOOL finished) {
        
    }];
    
    //判断是否碰到大球
//    [self runningBalltoDetermintoHit:_runningBigBall];
    
    
    //目标位置有prey，分数+1
    if (_currentIndex == _preyIndex && !_preyView.hidden) {
        
        _preyView.hidden = YES;
        //分数+1
        if (aimblock) {
            aimblock(YES);
        }
        
        addedNum++;

        
        //+1 show
        [self showScoreLabelGetting];
        
        if (addedNum%10 == 0) {

            [self performSelector:@selector(delaytoShowNextPreyVew) withObject:nil afterDelay:1];
            return;
        }
        //      显示prey下一个位置
        [self showPreyView];
    }
}

- (void)delaytoShowNextPreyVew {
    
    //      显示prey下一个位置
    [self showPreyView];
}

- (void)showScoreLabelGetting {
    
    _showGetScoreLabel.centerX = _dodgeball.centerX+_collectionView.left;
    _showGetScoreLabel.bottom = _dodgeball.top+_collectionView.top;
    _showGetScoreLabel.hidden = NO;
    
    [UIView animateWithDuration:0.8 animations:^{
        self->_showGetScoreLabel.centerY = self->_showGetScoreLabel.top;
    } completion:^(BOOL finished) {
        self->_showGetScoreLabel.hidden = YES;
        
    }];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 4) {
        
        _dodgeball.frame = CGRectMake(0, 0, 25, 25);
//        _dodgeball.backgroundColor = [UIColor ];
        [collectionView addSubview:_dodgeball];
        _dodgeball.center = cell.center;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:(float)1/60 target:self selector:@selector(gameRulesJudgement) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }
    
    if (indexPath.row == 8) {
        
        [self showPreyView];
    }
    
    return cell;
}

- (void)gameRulesJudgement {}

@end
