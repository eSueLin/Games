//
//  SCGameAreaView.m
//  SweetCandy
//
//  Created by HC16 on 6/2/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCGameAreaView.h"

@interface SCGameAreaView ()<HLCheckerRulesDelegate>

@end

@implementation SCGameAreaView
{
    UIView *_gameAreaView;
    HLCheckersRules *_gameRules;
    SCGameViewLevel _currentLevel;
    NSDictionary *levelDict;
    NSInteger _currentBoardNum;
    
    UIView * _gameView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (SCGameAreaView *)shareInstance {
    
    static SCGameAreaView *_gameArea = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gameArea = [[SCGameAreaView alloc] init];
    });
    return _gameArea;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gameRules = [[HLCheckersRules alloc] init];
        _gameRules.delegate = self;
        
        [self getConfigData];
    }
    return self;
}

- (void)getStageWithLevel:(SCGameViewLevel)level gameAreaBottomView:(UIImageView *)gameArea left:(nonnull void (^)(int))leftblock {
    
    _gameView = [[UIView alloc] initWithFrame:gameArea.frame];
    _gameView.backgroundColor = [UIColor clearColor];
    
    _currentLevel = level;
    [self refreshRulesData];
    CGFloat width =  (gameArea.width-40)/[self getBoardNum:level];
    _gameRules.checkerboardSize = CGSizeMake(width, width);
    
    switch (level) {
        case SCGameViewLevelOne:
        {
            [self refreshLevelOneView:width gameArea:gameArea];
        }
            break;
        case SCGameViewLevelTwo:
        {
            [self refreshLevelTwoViewWithBoardWidth:width gameArea:gameArea];
        }
            break;
        case SCGameViewLevelThr:
        {
            [self refreshLevelThrViewWithBoardWidth:width gameArea:gameArea];
        }
            break;
        case SCGameViewLevelFour:
        {
            [self refreshLevelFourViewWithBoardWidth:width gameArea:gameArea];
        }
            break;
        case SCGameViewLevelFive:
        {
            [self refreshLevelFiveViewWithBoardWidth:width gameArea:gameArea];
        }
            break;
        case SCGameViewLevelSix:
        {
            [self refreshSixViewWithBoardWidth:width gameArea:gameArea];
        }
            break;
            
    }
    
    if (leftblock) {
        leftblock((int)_gameRules.chessmenMutaArray.count);
    }
    _gameAreaView = [gameArea superview];
    [_gameAreaView addSubview:_gameView];
}

- (void)refreshRulesData {
    
    if (_gameRules.chessmenMutaArray.count) {
        [_gameRules.chessmenMutaArray removeAllObjects];
    }
    
    if (_gameRules.checkerboardMutaArray.count) {
        [_gameRules.checkerboardMutaArray removeAllObjects];
    }
    
}

- (UIImageView *)refreshBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea ki:(int)i kj:(int)j{
    
    UIImageView *board = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_d6"]];
    board.frame = CGRectMake(20+i*width, 25+j*width, width, width);
    [_gameView addSubview:board];
    [_gameRules.checkerboardMutaArray addObject:@(board.center)];
    
    return board;
}

- (void)refreshCandyBoardWithgameArea:(UIView *)gameArea candyImageName:(NSString *)imgName board:(UIView *)board ki:(int)i kj:(int)j{
    
    UIImageView *candy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [candy imageViewForCheckersWithFrame:CGRectMake(0, 0, board.width-2, board.width-2) ImageName:imgName tag:100+10*i+j];
    candy.center = board.center;
    candy.gestureDelegate = self;
    [_gameView addSubview:candy];
    [_gameRules.chessmenMutaArray addObject:candy];
}

#pragma mark -
#pragma mark - stages show view
- (void)refreshLevelOneView:(CGFloat)width gameArea:(UIView *)gameArea  {
    
    for (int i = 0 ; i < 4; i++) {
        for (int j = 0;  j < 4; j++) {
            
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];
            if (i < 3) {
                
                if ((i == 2 && j == 0) || (i == 0 && j == 3)) {
                    
                    continue;
                }
                [self refreshCandyBoardWithgameArea:gameArea
                                     candyImageName:[self stringFormatForImageName]
                                              board:board
                                                 ki:i
                                                 kj:j];
            }
        }
    }
}

- (void)refreshLevelTwoViewWithBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea
{
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];

            if (i == 0 || j == 0) {
                continue;
            }
            
            if ((i == 2 && j > 2 ) || (j==2&&i>2)) {
                continue;
            }
            
            [self refreshCandyBoardWithgameArea:gameArea
                                 candyImageName:[self stringFormatForImageName]
                                          board:board
                                             ki:i kj:j];
        }
    }
}

- (void)refreshLevelThrViewWithBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea
{
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
           
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];

            if (i<3&&j>1) {
                continue;
            }
            
            [self refreshCandyBoardWithgameArea:gameArea
                                 candyImageName:[self stringFormatForImageName]
                                          board:board
                                             ki:i kj:j];
        }
    }
}

- (void)refreshLevelFourViewWithBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea {
    
    for (int i = 0; i < 6; i++) {
        
        for (int j = 0; j < 6; j++) {
            
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];
            
            if (i == 0) {
                
                if (j == 4) {
                    continue;
                }
                
            } else if (j == 2 && i < 5) {
                if (i == 2) {
                    continue;
                }
                
            }else {
                
                continue;
            }
            
            [self refreshCandyBoardWithgameArea:gameArea
                                 candyImageName:[self stringFormatForImageName]
                                          board:board
                                             ki:i kj:j];
        }
        
    }
}

- (void)refreshLevelFiveViewWithBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea {
    
    for (int i = 0; i < _currentBoardNum; i++) {
        for (int j = 0; j < _currentBoardNum; j++) {
            
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];
        
            if (i == 3) {
                if (j == 0 || j==_currentBoardNum-1) {
                    continue;
                }
            } else if (j == 3) {
                
                if (i == 0 || i == _currentBoardNum-1) {
                    continue;
                }
            }else {
                
                continue;
            }
            
            [self refreshCandyBoardWithgameArea:gameArea
                                 candyImageName:[self stringFormatForImageName]
                                          board:board
                                             ki:i kj:j];
        }
    }
}

- (void)refreshSixViewWithBoardWidth:(CGFloat)width gameArea:(UIView *)gameArea {
    
    for (int i = 0; i < _currentBoardNum; i++) {
        for (int j = 0; j < _currentBoardNum; j++) {
            
            UIView *board = [self refreshBoardWidth:width gameArea:gameArea ki:i kj:j];
            if (j == 3 || j == 4) {
                if (i == 2 || i == 5) {
                    continue;
                }
                
                [self refreshCandyBoardWithgameArea:gameArea
                                     candyImageName:[self stringFormatForImageName]
                                              board:board
                                                 ki:i kj:j];
            }
        }
    }
    
}


#pragma mark -
#pragma mark - something useful method
- (NSString *)stringFormatForImageName {
    
    return [NSString stringWithFormat:@"colour%ld", _currentLevel];
}

- (void)imageViewMovedWithGesture:(UIPanGestureRecognizer *)ges {
    
    [_gameRules chessmanMovedWithPanGesture:ges withSurperView:_gameView];
}

- (void)getConfigData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CandyConfig" ofType:@"plist"];
    levelDict = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (NSInteger)getBoardNum:(SCGameViewLevel)level{
    
    NSInteger boardNum = [[levelDict objectForKey:[NSString stringWithFormat:@"%ld", level]] integerValue];
    
    _currentBoardNum = boardNum;
    
    return boardNum;
}

- (void)removeCurrentView {
    if (_gameView) {
        [_gameView removeAllSubviews];
        [_gameView removeFromSuperview];
    }
}


#pragma mark - game rules delegate
- (void)checkerRulesRemoveChessmanWithRest:(NSInteger)count {
    
    if ([self.delegate respondsToSelector:@selector(checkerRulesRemoveChessmanWithRest:)]) {
        
        [self.delegate checkerRulesRemoveChessmanWithRest:count];
    }
}

- (void)checkerRulesGameOver {
    
    if ([self.delegate respondsToSelector:@selector(checkerRulesGameOver)]) {
        
        [self.delegate checkerRulesGameOver];
    }
}

- (void)checkerRulesGameSuceessful {
    
    if ([self.delegate respondsToSelector:@selector(checkerRulesGameSuceessful)]) {
        
        [self.delegate checkerRulesGameSuceessful];
    }
}

@end
