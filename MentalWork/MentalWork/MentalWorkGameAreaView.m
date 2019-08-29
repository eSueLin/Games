//
//  MentalWorkGameAreaView.m
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkGameAreaView.h"
#import "UIView+Additions.h"
#import "MentalWorkBGMusic.h"

@implementation MentalWorkGameAreaView
{
    UIView *_gameArea;
    int _level;
    NSInteger _imagesTotal;
    NSMutableArray *_gameImageVsArr;
    NSMutableArray *_imageNames;
    NSMutableArray *_showCards;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithGameArearView:(UIView *)gameArea level:(int)level imageNames:(NSMutableArray *)imageNames
{
    self = [super init];
    if (self) {
        
        _gameArea = gameArea;
        _level = level;
        _imageNames = imageNames;
        _imagesTotal = imageNames.count;
        _showCards = [NSMutableArray array];
    }
    return self;
}

- (void)createGameAreaWithVer:(int)ki hor:(int)kj {
    
    _gameImageVsArr = [NSMutableArray array];
    
    //194x234
    float imageH = _gameArea.height/ki;
    float imageW = imageH/234*194;
    
    float spacingW = 10;
    float spacingH = 5;
    
    self.frame = CGRectMake(0, 0, (imageW+spacingW)*kj-spacingW, _gameArea.height);
    self.center = _gameArea.center;
    
    int k = 0;
    for (int i = 0; i < ki; i++) {
        for (int j = 0; j < kj; j++) {
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(j*(imageW+spacingW), 10+i*imageH, imageW, imageH-spacingH)];
            [imgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%i", _level]]];
            imgV.tag = 200+k;
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            imgV.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [tap addTarget:self action:@selector(tap:)];
            [imgV addGestureRecognizer:tap];
            
            [_gameImageVsArr addObject:imgV];
            [self addSubview:imgV];
            
            k++;
        }
    }
    
}

#pragma mark - gesture
- (void)tap:(UIGestureRecognizer *)ges {
    
    //click the image and show the card
    UIImageView *imgV = (UIImageView *)ges.view;
    int tag = (int)imgV.tag - 200;
    [imgV setImage:[UIImage imageNamed:[_imageNames objectAtIndex:tag]]];
    [self setAnimationWithview:imgV];
    imgV.userInteractionEnabled = NO;
    //add bgm
    
    if (0 == _showCards.count) {
        [_showCards addObject:@[imgV, _imageNames[tag]]];
        return;
    }
    
    self.userInteractionEnabled = NO;
    NSArray *arr = _showCards[0];
    if ([arr[1] isEqualToString: [_imageNames objectAtIndex:tag]]) {
        
        //判断是否同一张，是的话消除
        [self performSelector:@selector(performSelWithObject:) withObject:@[arr[1], [NSString stringWithFormat:@"%i", tag], arr, imgV] afterDelay:1];
        
    } else {
        
        //不同的话不做处理，翻回背面
        [self performSelector:@selector(differentCardShows:) withObject:@[arr[0], imgV] afterDelay:1];
    }
}

- (void)setAnimationWithview:(id)objectView {
    
    UIImageView *imgV = (UIImageView *)objectView;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    // 设定动画选项
    animation.duration = 0.1; // 持续时间
    animation.repeatCount = 1; // 重复次数
    
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:M_PI]; // 终止角度
    
    // 添加动画
    [imgV.layer addAnimation:animation forKey:@"rotate-layer"];
    
}

- (void)differentCardShows:(NSArray *)object {
    
    UIImageView *img1 = object[0];
    UIImageView *img2 = object[1];
    
    NSString *cardName = [NSString stringWithFormat:@"card_%i", _level];
    [img1 setImage:[UIImage imageNamed:cardName]];
    [img2 setImage:[UIImage imageNamed:cardName]];
    [_showCards removeObjectAtIndex:0];
    self.userInteractionEnabled = YES;
    img1.userInteractionEnabled = YES;
    img2.userInteractionEnabled = YES;
    
    [[MentalWorkBGMusic sharedInstance] bgmforfailedflipingCards];

}

- (void)performSelWithObject:(NSArray *)obj {

    [[MentalWorkBGMusic sharedInstance] bgmforCleanningCards];

    [self hideImageWithImgTag1:obj[0] imgTag2:obj[1] withRemoveArr:obj[2] withOriImgV:obj[3]];
}

- (void)hideImageWithImgTag1:(NSString *)tag1 imgTag2:(NSString *)tag2 withRemoveArr:(NSArray *)arr withOriImgV:(UIImageView *)imgV{
    
    NSString *nullStr = @"";
    UIImageView *sameImgv = arr[0];
    [sameImgv setImage:[UIImage imageNamed:@""]];
    [imgV setImage:[UIImage imageNamed:@""]];
    
    NSArray *cardsName = [NSArray arrayWithArray:_imageNames];
    for (NSString *str in cardsName) {
        
        if ([str isEqualToString: arr[1]]) {
            
            [_imageNames replaceObjectAtIndex:[_imageNames indexOfObject:str] withObject:nullStr];
            _imagesTotal--;
            //消除一组获得10分
            
     
            if ([self.delegate respondsToSelector:@selector(mwGameAreaCleaning)]) {
                
                [self.delegate mwGameAreaCleaning];
            
            }
        }
    }
    [_showCards removeObject:arr];
    
    if (_imagesTotal == 0 || _imagesTotal == 1) {
        
        //完成游戏
        if ([self.delegate respondsToSelector:@selector(mwGameAreaCompleted)]) {
            
            [self.delegate mwGameAreaCompleted];
        }
    }
    self.userInteractionEnabled = YES;
    
}
@end
