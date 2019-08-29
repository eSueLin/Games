//
//  HLPinkCheckerView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/26.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLPinkCheckerView.h"

@interface HLPinkCheckerView()<UIImageViewCheckersDelegate>

@end

@implementation HLPinkCheckerView

- (void)setImageViewforCheckerboard {

//    self.backgroundColor = [UIColor clearColor];
//    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20);
    
    self.checkerFallenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/7, [UIScreen mainScreen].bounds.size.width/7);
    self.rules.checkerboardSize = self.checkerFallenSize;
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < i+1; j++) {
            
            CGPoint point = CGPointMake(0, 0);
            
            point = CGPointMake(ScreenWith/2+(j-(CGFloat)i/2)*self.checkerFallenSize.width, self.checkerFallenSize.height*(i+1));
            
            UIImageView *checkerboardImgV = [[[UIImageView alloc] init] normalWithFrame:CGRectMake(point.x, point.y, self.checkerFallenSize.width-15, self.checkerFallenSize.width-15) ImageName:@"棋盘" tag:10*i+j+100];
            checkerboardImgV.center = point;

            UIImageView *chessmanImgV = [[UIImageView alloc] init];
            [chessmanImgV imageViewForCheckersWithFrame:CGRectMake(0, 0, checkerboardImgV.width-4, checkerboardImgV.width-4) ImageName:@"棋子粉" tag:10*i+j+10+200];
            chessmanImgV.center = point;
            chessmanImgV.checkersDelegate = self;
            
            [self.rules.checkerboardMutaArray addObject:@(point)];

            [self addSubview:checkerboardImgV];
            if (i == 3 && j == 1) {
             
                [chessmanImgV removeFromSuperview];
                continue;
            }
            
            [self.rules.chessmenMutaArray addObject:chessmanImgV];
            [self addSubview:chessmanImgV];
        }
    }
}

- (void)checkersChessmanMoveWithGesture:(UIPanGestureRecognizer *)ges {
    
    [self.rules chessmanMovedWithPanGesture:ges withSurperView:self];
}
@end
