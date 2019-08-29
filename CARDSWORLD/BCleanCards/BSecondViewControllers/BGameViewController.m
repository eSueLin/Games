//
//  BGameViewController.m
//  BCleanCards
//
//  Created by HC16 on 5/9/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BGameViewController.h"
#import "../BSetup/BSetupHeader.h"
#import "Founction/BFouctionHeader.h"
#import "BViews/BViewsHeader.h"

static int const kBGameTimer = 60;
@interface BGameViewController ()<UIGestureRecognizerDelegate, BGameTimerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *gameArea;
@property (weak, nonatomic) IBOutlet UIImageView *nPokerImgV1;
@property (weak, nonatomic) IBOutlet UIImageView *nPokerImgV2;
@property (weak, nonatomic) IBOutlet UIImageView *nPokerImgV3;
@property (weak, nonatomic) IBOutlet UIImageView *nPokerImgV4;
@property (weak, nonatomic) IBOutlet UIImageView *timeLeftImgV;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImgV;

//发牌去展示的po位置
@property (strong, nonatomic) NSMutableArray *dealPokersPointMutaArr;
//记录发牌展示区图片
@property (strong, nonatomic) NSMutableArray *dealPokersImgVMutaArr;

//待发p
@property (strong, nonatomic) NSMutableArray *pendPokersMutaArr;
/**发牌区移动的扑克牌初始位置**/
@property (assign, nonatomic) CGPoint movedPokerCenter;
@property (assign, nonatomic) NSInteger movedPokerTag;

/** 游戏区域p落点位置 **/
//每一项:[@{x:i,y:j}, point](@[序列点, imageView])
@property (strong, nonatomic) NSMutableArray *bGamePokerLocMutaArr;

/** 游戏区域已有的p位置 **/
@property (strong, nonatomic) NSMutableArray *bGamePokersPointMutaArr;

/** p所放的位置，横列数列上的Ps **/
@property (strong, nonatomic) NSMutableArray *bGameAlignPokersMutaArr;
@property (strong, nonatomic) NSMutableArray *bGameColumnPokersMutaArr;

@property (assign, nonatomic) NSInteger removeImageViewLoc;

@end

@implementation BGameViewController
{
    CGFloat _pokerRHeight;
    CGFloat _pokerRWidth;
    BGameTimer *_timer;
    UILabel    *_scoreLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)backtoHomeView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

static bool _firstTime = YES;
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];

    if (_firstTime) {
        [self setBottomUI];
        [self initData];
        [self setDealArea];  //设置发牌区域
        [self setTimer];
        [self createScore];
        _firstTime = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    _firstTime = YES;
    [_timer turnDownTimer];
}

- (void)setTimer {
    
    _timer = [[BGameTimer alloc] initWithTotalTime:kBGameTimer];
    _timer.centerX = self.timeLeftImgV.right+_timer.width/2;
    _timer.centerY = self.timeLeftImgV.centerY;
    _timer.delegate = self;
    [self.view addSubview:_timer];

    [_timer turnOnTimer];
}

- (void)createScore {
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.font = [UIFont boldSystemFontOfSize:15];
    _scoreLabel.text = @"000";
    _scoreLabel.center = CGPointMake(_scoreImgV.right+_scoreLabel.width/2, _scoreImgV.centerY);
    
    [self.view addSubview:_scoreLabel];
    
    [[BGameRules defaultRules] dataWithScoreLabel:_scoreLabel superView:self.view];
}

- (void)initData {
    
    self.dealPokersImgVMutaArr = [NSMutableArray array];
    self.dealPokersPointMutaArr = [NSMutableArray array];
    self.pendPokersMutaArr = [NSMutableArray arrayWithArray:[self setpokers]];
    self.bGamePokersPointMutaArr = [NSMutableArray array];
    self.bGameAlignPokersMutaArr = [NSMutableArray array];
    self.bGameColumnPokersMutaArr = [NSMutableArray array];
}

- (NSMutableArray *)setpokers{
    
    NSMutableArray *pokers = [NSMutableArray array];
    
    //将poker放到数组
    NSMutableArray *inturnPokers = [NSMutableArray array];
    //i是花色，j是点数
    for (int i = 1; i < 5; i++) {
        for (int j = 1; j < 14; j++) {
            
            NSString *imageName = [NSString stringWithFormat:@"poker_%i_%i", j, i];
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imgV.frame = CGRectMake(0, 0, _pokerRWidth, _pokerRHeight);
            imgV.tag = 1000+100*i+j;
            [inturnPokers addObject:imgV];
        }
    }
    
//    NSLog(@"inturnPokers.count:%lu", inturnPokers.count);
    //重排
    do {
        
        NSUInteger rand = arc4random()%inturnPokers.count;
        [pokers addObject: [inturnPokers objectAtIndex:rand]];
        [inturnPokers removeObjectAtIndex:rand];
        
    } while (inturnPokers.count > 0);
    
    return pokers;
}

- (void)setBottomUI {
    
    CGFloat gameAreaX = self.gameArea.left;
    CGFloat gameAreaY = self.gameArea.top;
    CGFloat pokerHeight = (self.gameArea.height-16)/5;
    CGFloat pokerWidth  = (self.gameArea.width-16)/5;
    CGFloat gapH = 3;
    CGFloat gapW = 6;
    
    _pokerRWidth = pokerWidth-gapW;
    _pokerRHeight = pokerHeight-gapH;
    
    self.bGamePokerLocMutaArr = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            
            CGFloat pointx = gameAreaX+8+pokerWidth*i+gapW;
            CGFloat pointy = gameAreaY+8+pokerHeight*j+gapH;
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bdk"]];
            imgV.frame = CGRectMake(pointx, pointy, pokerWidth-gapW, pokerHeight-gapH);
            imgV.tag = 100+i*10+j;
            NSMutableDictionary *seqDict = [NSMutableDictionary dictionary];
            [seqDict setValue:@(i) forKey:@"x"];
            [seqDict setValue:@(j) forKey:@"y"];
            [self.bGamePokerLocMutaArr addObject:@[seqDict, imgV]];
            
            [self.view addSubview:imgV];
            
        }
    }
}

//设置发牌区域
 int imageCount = 0;
- (void)setDealArea{
    
    //先判定剩下j几张牌
//    if (self.pendPokersMutaArr.count <= 4) {
    
//    if (self.pendPokersMutaArr.count == 0) {
//        UIImageView *deal = [self.view viewWithTag:19];
//        deal.image = [UIImage imageNamed:@""];
//        return;
//    }
////    }
//
//    if (self.dealPokersPointMutaArr.count<4) {
//        //发牌
//        if (self.dealPokersPointMutaArr.count == 0) {
//
//            for (int i = 0; i < 4; i++) {
//
//                UIImageView *pointImgV = [self.view viewWithTag:21+i];
//                [self addPokerImgVInDealAreaWithLocationPoint:pointImgV.center];
//                [self.dealPokersPointMutaArr addObject:@(pointImgV.center)];
//            }
//            return;
//        }
//
//        //移走一张牌，记录那张牌的位置，下张牌可以直接找到位置
//        [self addPokerImgVInDealAreaWithLocationPoint:self.movedPokerCenter];
//        [self.dealPokersPointMutaArr addObject:@(self.movedPokerCenter)];
//    }
//
    if (imageCount > 4) {
        
        [self addImageViewForGameWithCenter:self.movedPokerCenter];
        return;
    }
    
    for (int i = 0; i < 5; i ++) {
        
        UIImageView *imgV = [self.view viewWithTag:20+i];
        [self addImageViewForGameWithCenter:imgV.center];
        
    }
}

- (void)addImageViewForGameWithCenter:(CGPoint)point {
    
    NSInteger rand = arc4random()%9;
    
    UIImageView *imgV = [self.view viewWithTag:20];
    
    UIImageView *newImgV = [[UIImageView alloc] initWithFrame:imgV.frame];
    newImgV.center = point;
    newImgV.tag = 10*imageCount+rand+1;
    imageCount++;
//    NSLog(@">>>>>>%ld", rand);
    [newImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", rand+1]]];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [newImgV addGestureRecognizer:pan];
    newImgV.userInteractionEnabled = YES;
    
    [self.view addSubview:newImgV];
    [self.dealPokersImgVMutaArr addObject:newImgV];
}

- (void)addPokerImgVInDealAreaWithLocationPoint:(CGPoint)point {
    
    UIImageView *lastInPokersImgV = [self.pendPokersMutaArr lastObject];
  
    UIImageView *imgV = [self.view viewWithTag:21];
    lastInPokersImgV.size = imgV.size;
    lastInPokersImgV.center = point;
    [self.view addSubview:lastInPokersImgV];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [lastInPokersImgV addGestureRecognizer:pan];
    lastInPokersImgV.userInteractionEnabled = YES;
    
    [self.pendPokersMutaArr removeObject:lastInPokersImgV];
    [self.dealPokersImgVMutaArr addObject:lastInPokersImgV];
    
    
    
}

/** 结束游戏，统计分数并弹窗 **/
- (void)saveScoreAndShowGameOverView {
    
    //游戏结束,统计分数
    NSString *scoreStr = _scoreLabel.text;
    
    if ([scoreStr isEqualToString:@"000"]) {
        
        scoreStr = @"0";
    }
    
    [[BScoreStatic shareInstance] saveScore:scoreStr];
    
    NSArray *nibsArr = [[NSBundle mainBundle] loadNibNamed:@"BGameOver" owner:nil options:nil];
    BGameOver *oView = [nibsArr firstObject];
    oView.frame = self.view.frame;
    oView.scoreLabel.text = scoreStr;
    __block typeof(self) gameVC = self;
    oView.overblock = ^(BOOL isreplay) {
        
        //重玩
        if (isreplay) {
            
            [self playagain];
        } else {
            
            [gameVC dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [self.view.window addSubview:oView];
}

- (void)playagain {
    //重置时间
    _timer.totalTime = kBGameTimer;
    [_timer turnOnTimer];
    _scoreLabel.text = @"000";
    
    //移除存储加载在界面上s的图片
    for (NSArray *arr in self.bGamePokersPointMutaArr) {
        
        UIImageView *imgV = arr[1];
        [imgV removeFromSuperview];
    }
    [self.bGamePokersPointMutaArr removeAllObjects];
    
    //移除发P区图片
    for (UIImageView *imgV in self.dealPokersImgVMutaArr) {
        
        [imgV removeFromSuperview];
    }
    
    imageCount = 0;
    //移除所有数组数据
    [self.dealPokersImgVMutaArr removeAllObjects];
    [self.dealPokersPointMutaArr removeAllObjects];
    [self.pendPokersMutaArr removeAllObjects];
    [self.bGameAlignPokersMutaArr removeAllObjects];
    [self.bGameColumnPokersMutaArr removeAllObjects];
    [self initData];
    [self setDealArea];
    
//    UIImageView *deal = [self.view viewWithTag:19];
//    deal.image = [UIImage imageNamed:@"yilp"];
}

#pragma mark - timer delegate
- (void)countdownTimerbeRunofTime {
    
    [self saveScoreAndShowGameOverView];
}


#pragma mark - gesture delegate/respone
- (void)pan:(UIPanGestureRecognizer *)panGes {
    
    UIImageView *panImgV = (UIImageView *)[panGes view];
    CGPoint translatePoint = [panGes translationInView:self.view];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.movedPokerCenter = panImgV.center;
    }
    
    translatePoint = CGPointMake(translatePoint.x+self.movedPokerCenter.x, translatePoint.y+self.movedPokerCenter.y);
    panImgV.center = translatePoint;
    [self.view bringSubviewToFront:panImgV];
    
    if (panGes.state == UIGestureRecognizerStateEnded) {
        

        //分两种情况
        //情况一:道路千万条，顺道而行
     
        //限制落点区域
        //落点在游戏区域外的位置，p回到起点位置
        if (translatePoint.x<_gameArea.left || translatePoint.x > _gameArea.right || translatePoint.y < _gameArea.top || translatePoint.y > _gameArea.bottom) {
            
            panImgV.center = self.movedPokerCenter;
        } else {
            
            if (self.bGameAlignPokersMutaArr.count) {
                [self.bGameAlignPokersMutaArr removeAllObjects];
                [self.bGameColumnPokersMutaArr removeAllObjects];
            }
          
            //确定设置终点位置，(容差),遍历p位置数组
            for (id obj in self.bGamePokerLocMutaArr) {
                
                CGPoint point = [(UIImageView *)[(NSArray*)obj objectAtIndex:1] center];
                NSDictionary *seqDict = [(NSArray *)obj objectAtIndex:0];
                
                if (fabs(point.x-translatePoint.x) <= (_pokerRWidth+6)/2 && fabs(point.y-translatePoint.y) <= (_pokerRHeight+3)/2) {
                    
                    //判断对应位置上是否存在p
                    BOOL hadPoker = NO;
                    for (id pObj in self.bGamePokersPointMutaArr) {
            
                        UIImageView *pokerImgV = (UIImageView *)[(NSArray *)pObj objectAtIndex:1];
                        CGPoint pokerPoint = [pokerImgV center];
                        //判断对应位置是否被占用
                        if (point.x == pokerPoint.x && point.y == pokerPoint.y) {
            
                            hadPoker = YES;
                            panImgV.center = self.movedPokerCenter;
                            
                            //位置被占用，清空统计数组
                            [self.bGameAlignPokersMutaArr removeAllObjects];
                            [self.bGameColumnPokersMutaArr removeAllObjects];
                            
                            break;
                        }
                        
                        //获取对应位置横列纵列图片
                        [self statisWithAimsImgVSeq:seqDict staticalImgArr:pObj];
                    }
                    if (hadPoker) {
                        break;
                    }
                    
                    //综上判断，p可移动到对应位置
                    //p落点位置，序列+
                    NSArray *panPokerArr = @[seqDict, panImgV];
                    //将p添加到组合列表中(横纵都需要添加p 以便处理)
                    [[BGameRules defaultRules] insertDatatoCollectionforGameRule:[seqDict[@"y"] integerValue]
                                                           withCollectionArr:self.bGameColumnPokersMutaArr
                                                               withInsertArr:@[seqDict[@"y"], panImgV]];
                    [[BGameRules defaultRules] insertDatatoCollectionforGameRule:[seqDict[@"x"] integerValue]
                                                           withCollectionArr:self.bGameAlignPokersMutaArr
                                                               withInsertArr: @[seqDict[@"x"], panImgV]];

                    
                    panImgV.size = CGSizeMake(_pokerRWidth, _pokerRHeight);
                    [self.dealPokersPointMutaArr removeObject:@(self.movedPokerCenter)];
                    [self.dealPokersImgVMutaArr removeObject:panImgV];
//                    self.removeImageViewLoc =
                    [self setDealArea]; //设置发牌区域
                    
                    
                    panImgV.center = point;
                    [panImgV removeGestureRecognizer:panGes];
                    [self.bGamePokersPointMutaArr addObject:panPokerArr]; //收集在游戏区的图片，以及图片序列位置

                    //确定落点-->进入游戏环节h判断
                    [BGameRules defaultRules].cleanedCards = ^(int cleanNum) {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
                        label.left = self->_timer.right-10;
                        label.centerY = self->_timer.centerY;
                        label.textColor = [UIColor whiteColor];
                        label.text = @"+5s";
                        [self.view addSubview:label];
                        [UIView animateWithDuration:1 animations:^{
    
                            label.centerY = self->_timer.top;
                       
                        } completion:^(BOOL finished) {
                            label.alpha = 0;
                            [label removeFromSuperview];
                        }];
                        [self->_timer addTime:5];
                    };
                    
                    [[BGameRules defaultRules] gameRulesWithAlignPokesArr:self.bGameAlignPokersMutaArr column:self.bGameColumnPokersMutaArr pokersArr:self.bGamePokersPointMutaArr];
                    
//                    //判断游戏是否结束(剩下数量)
//                    //判断发牌区域是否有p
//                    if (self.dealPokersPointMutaArr.count == 0) {
//                        //游戏结束(展示f存储分数)
//                        [self saveScoreAndShowGameOverView];
//                        [_timer turnDownTimer];
//                    }
                    
                    break;
                }
            }
            
        }
    }
}

- (void)statisWithAimsImgVSeq:(NSDictionary *)seqDic staticalImgArr:(NSArray *)staticalArr{
    
    //对比其他位置上的p
    //新的p落点位置
    NSInteger aimX = [seqDic[@"x"] integerValue];
    NSInteger aimY = [seqDic[@"y"] integerValue];
    
    NSDictionary *staticalSeq = staticalArr[0];
    UIImageView  *staticalImgV = staticalArr[1];
    
    NSInteger staticalX = [staticalSeq[@"x"] integerValue];
    NSInteger staticalY = [staticalSeq[@"y"] integerValue];
    
    //纵列组合, 对比获取横纵位置上p，顺序插入放进数组
    if (aimX == staticalX) {
        
        [[BGameRules defaultRules] insertDatatoCollectionforGameRule:staticalY
                              withCollectionArr:self.bGameColumnPokersMutaArr
                                  withInsertArr:@[@(staticalY), staticalImgV]];
    }
    
    //横列组合
    if (aimY == staticalY) {
        
        [[BGameRules defaultRules] insertDatatoCollectionforGameRule:staticalX
                              withCollectionArr:self.bGameAlignPokersMutaArr
                                  withInsertArr:@[@(staticalX), staticalImgV]];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    imageCount = 0;
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
