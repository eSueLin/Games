//
//  BGameRules.m
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BGameRules.h"
#import <UIKit/UIKit.h>
#import "../../BSetup/BSetupHeader.h"

@implementation BGameRules
{
    UILabel *_scoreLabel;
    UIView  *_surperView;
    NSMutableArray * _bGamePokersMutaArr;
}

static BGameRules *_rules = nil;
+ (BGameRules *)defaultRules {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rules = [[BGameRules alloc] init];
    });
    
    return _rules;
}


- (void)dataWithScoreLabel:(id)label superView:(id)superView{
    _scoreLabel = label;
    _surperView = superView;
//    _bGamePokersMutaArr = pokersArr;
}

//横纵数组集合，方便p判断p可否消除
- (NSInteger)insertDatatoCollectionforGameRule:(NSInteger)statical withCollectionArr:(NSMutableArray *)collectArr withInsertArr:(NSArray*)insertArr{
    
    NSInteger statiLoc = 0;
    NSInteger insertLoc = [[insertArr objectAtIndex:0] integerValue];
    for (NSArray *arr in collectArr) {
        
        NSInteger loc = [arr[0] integerValue];
        NSInteger index = [collectArr indexOfObject:arr];
        if (loc < insertLoc) {
            
            statiLoc = index+1;
            
        } else if(loc > insertLoc){
            statiLoc = index;
            break;
        }
    }
    
    [collectArr insertObject:insertArr atIndex:statiLoc];
    
    return statiLoc;
}

- (void)gameRulesWithAlignPokesArr:(NSMutableArray *)alignArr column:(NSMutableArray *)columnArr pokersArr:(NSMutableArray *)pokersArr{
    
    //获取牌点..p点数通过tag确定，tag设定花色*100+点数+1000
    //p点数
//    if (self.bGameAlignPokersMutaArr.count<3&&self.bGameColumnPokersMutaArr.count<3) {
//
//        return;
//    }
    
    if (alignArr.count > 2) {
        [[BGameRules defaultRules] estimatedPokersInGameWithArr:alignArr pokersArr:pokersArr];
    }
    if (columnArr.count > 2) {
        [[BGameRules defaultRules] estimatedPokersInGameWithArr:columnArr pokersArr:pokersArr];
        
    }
}


- (void)estimatedPokersInGameWithArr:(NSArray *)gameArr pokersArr:(nonnull NSMutableArray *)pokerArr{
    
    _bGamePokersMutaArr = pokerArr;
    
    NSInteger equalCount = 0; //相等个数
    NSInteger descendCount = 0; //降序个数
    NSInteger ascendCount = 0; //升序个数
    NSMutableArray *equalmutaArr = [NSMutableArray array];
    NSMutableArray *descendmutaArr = [NSMutableArray array];
    NSMutableArray *ascendmutaArr = [NSMutableArray array];
    for (int i = 0; i < gameArr.count; i++) {
        
        if (i == gameArr.count-1) {
            break;
        }
        
        NSArray *arr = gameArr[i];
        NSArray *arrNxt = gameArr[i+1];
        
        NSInteger arrloc = [arr[0] integerValue];
        NSInteger arrNxtLoc = [arrNxt[0] integerValue];
        
        //对比同行或者同列是否构成可消除条件（针对3～4可能出现间隔空情况）
        
        if (gameArr.count == 3) {
            if (arrloc != arrNxtLoc -1 ) {
                //  出现隔层，不成立
                
                return;
            }
        } else if (gameArr.count == 4) {
            //落点位置中间出现空格，不连续：第2/3/4
            if (arrloc == 1 && arrloc != arrNxtLoc -1) {
                //一行或一列有4个，当为2时出现隔层，不成立
                
                return;
            }
            if  (arrloc == 0 && arrloc != arrNxtLoc-1) {
                continue;
            }
            if (arrloc == 2 && arrloc != arrNxtLoc -1) {
                continue;
            }
        }
        
        NSInteger arrPoint = [self getPointWithImageView:(UIImageView *)arr[1]];
        NSInteger nxtPoint = [self getPointWithImageView:(UIImageView *)arrNxt[1]];
        
        //        if (i == 0) {
        if (arrPoint == nxtPoint) {
            
            equalCount++;
            [self addObjectWithMutaArr:equalmutaArr object:arr[1]];
            [self addObjectWithMutaArr:equalmutaArr object:arrNxt[1]];
        }
        
        if (arrPoint==nxtPoint-1) {
            
            ascendCount++;
            [self addObjectWithMutaArr:ascendmutaArr object:arr[1]];
            [self addObjectWithMutaArr:ascendmutaArr object:arrNxt[1]];
        }
        if (arrPoint==nxtPoint+1) {
            
            descendCount++;
            [self addObjectWithMutaArr:descendmutaArr object:arr[1]];
            [self addObjectWithMutaArr:descendmutaArr object:arrNxt[1]];
        }
    }
    
    if ([self conformsEqualCollection:equalmutaArr]) {
        [self estimatedPokerstoCleanWithCleanArr:equalmutaArr];
    }
    
    if ([self conformAscendCollection:ascendmutaArr]) {
        [self estimatedPokerstoCleanWithCleanArr:ascendmutaArr];
    }
    if ([self conformDescendCollection:descendmutaArr]) {
        [self estimatedPokerstoCleanWithCleanArr:descendmutaArr];
    }
}

- (BOOL)conformsEqualCollection:(NSMutableArray *)arr {
    
    NSArray *collectionArr = arr;
    for (int i = 0; i < collectionArr.count; i++) {
        
        if (i == collectionArr.count-1) {
            return YES;
        }
        UIImageView *img1 = collectionArr[i];
        UIImageView *img2 = collectionArr[i+1];
        
        NSInteger tag1 = [self getPointWithImageView:img1];
        NSInteger tag2 = [self getPointWithImageView:img2];
        
        if (tag1 != tag2) {
            
            if (collectionArr.count == 5) {
                if (i >= 2) {
                    
                    for (int j = i+1; j < 5; j++) {
                        
                        [arr removeLastObject];
                    }
                    return YES;
                }else if (i < 2) {
                    
                    for (int j = 0; j < i+1; j++) {
                        
                        [arr removeObjectAtIndex:0];
                    }
                    continue;
                }
            }
            
            
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)conformAscendCollection:(NSMutableArray *)arr {
    
    NSArray *collectionArr = arr;
    
    for (int i = 0; i < collectionArr.count; i++) {
        
        if (i == collectionArr.count-1) {
            return YES;
        }
        UIImageView *img1 = collectionArr[i];
        UIImageView *img2 = collectionArr[i+1];
        
        NSInteger tag1 = [self getPointWithImageView:img1];
        NSInteger tag2 = [self getPointWithImageView:img2];
        
//        if (collectionArr.count == 5 && i == 2 && arr.count < 5) {
//            UIImageView *img3 = collectionArr[i+2];
//            NSInteger tag3 = [self getPointWithImageView:img3];
//
//            if (tag1 == tag2-1 && tag2 == tag3-1 ) {
//                [arr removeObjectAtIndex:0];
//                [arr removeObjectAtIndex:0];
//                return YES;
//            }
//        }
        
        if (tag1 != tag2-1) {
            if (collectionArr.count == 5) {
                if (i < 2) {
                    for (int j = 0; j <= i; j++) {
                        [arr removeObjectAtIndex:0];
                    }
                    continue;
                } else if (i < 4 && arr.count == 5) {
                    
                    for (int j = i+1; j < 5; j++) {
                        [arr removeLastObject];
                    }
                    return YES;
                }
            }
            return NO;
        }
        
    }
    return YES;
}
- (BOOL)conformDescendCollection:(NSMutableArray *)arr {
    
    NSArray *collectionArr = arr;
    
    for (int i = 0; i < collectionArr.count; i++) {
        
        if (i == collectionArr.count-1) {
            return YES;
        }
        UIImageView *img1 = collectionArr[i];
        UIImageView *img2 = collectionArr[i+1];
        
        NSInteger tag1 = [self getPointWithImageView:img1];
        NSInteger tag2 = [self getPointWithImageView:img2];
        
//        if (collectionArr.count == 5 && i == 2) {
//            UIImageView *img3 = collectionArr[i+2];
//            NSInteger tag3 = [self getPointWithImageView:img3];
//
//            if (tag1 == tag2-1 && tag2 == tag3-1) {
//                [arr removeObjectAtIndex:0];
//                [arr removeObjectAtIndex:0];
//                return YES;
//            }
//        }
        if (tag1 != tag2+1) {
            if (collectionArr.count == 5) {
                if (i < 2) {
                    for (int j = 0; j <= i; j++) {
                        [arr removeObjectAtIndex:0];
                    }
                    continue;
                } else if (i < 4 && arr.count == 5) {
                    
                    for (int j = i+1; j < 5; j++) {
                        [arr removeLastObject];
                    }
                    return YES;
                }
            }
            return NO;
        }
        
    }
    return YES;
}

- (NSInteger)getPointWithImageView:(UIImageView *)imgV {
    
    return imgV.tag%10;
}

- (void)addObjectWithMutaArr:(NSMutableArray *)mutaArr object:(UIImageView *)obj {
    
    if ([mutaArr containsObject:obj]) {
        
        return;
    }
    [mutaArr addObject:obj];
}

- (void)estimatedPokerstoCleanWithCleanArr:(NSMutableArray*)mutArr {
    
    if (mutArr.count >= 3) {
        //could be clean cards
        [self showScoreinCleanAreaforCleanArr:mutArr];
        
        //send message to notice
        if (self.cleanedCards) {
            self.cleanedCards(1);
        }
    }
}

- (void)showScoreinCleanAreaforCleanArr:(NSMutableArray *)mutaArr {
    
    //确定线框，框出可消除图片
    UIImageView *imgV0 = [mutaArr firstObject];
    UIImageView *imgVlast = [mutaArr lastObject];
    
    UIImageView *kImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fgkk"]];
    
    CGFloat kWidth = (imgVlast.left-imgV0.left) == 0?imgV0.width+8:(imgVlast.right-imgV0.left+8);
    CGFloat kHeight = (imgVlast.top-imgV0.top) == 0?imgV0.height+8:(imgVlast.bottom-imgV0.top+8);
    
    kImgV.frame = CGRectMake(imgV0.left-4, imgV0.top-4, kWidth, kHeight);
    [kImgV.layer addAnimation:[self opacity_Animation:2] forKey:nil];
    
    [_surperView addSubview:kImgV];
    
    
    UIImageView *scoreImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];
    scoreImgV.contentMode = UIViewContentModeScaleAspectFit;
    scoreImgV.center =kImgV.center;
    
    NSString *sImgName = [NSString stringWithFormat:@"%lu00", (unsigned long)mutaArr.count];
    [scoreImgV setImage:[UIImage imageNamed:sImgName]];
    
    [_surperView addSubview:scoreImgV];
    
    NSMutableArray *objectArr = [NSMutableArray arrayWithObjects:mutaArr, kImgV, scoreImgV, nil];
    
    //1.移除p
    [self performSelector:@selector(cleanPokersWithCleanArr:) withObject:objectArr afterDelay:1.5];
    //2.计算分数:sImgName.integerValue
    NSInteger score = _scoreLabel.text.integerValue + sImgName.integerValue;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    
}

- (void)cleanPokersWithCleanArr:(NSArray *)objectArr  {
    
    NSMutableArray *mutaArr = objectArr[0];
    UIImageView *kImgV = objectArr[1];
    UIImageView *sImgV = objectArr[2];
    [kImgV removeFromSuperview];
    [sImgV removeFromSuperview];
    kImgV = nil;
    sImgV = nil;
    
    for (UIImageView* imgV  in mutaArr) {
        
        NSArray *removeArr;
        for (NSArray *arr in _bGamePokersMutaArr) {
            
            if (imgV == arr[1]) {
                removeArr = arr;
                break;
            }
        }
        [_bGamePokersMutaArr removeObject:removeArr];
        [imgV removeFromSuperview];
    }
}

//闪烁动画
- (CABasicAnimation*)opacity_Animation:(float)time {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

@end
