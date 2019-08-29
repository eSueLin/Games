//
//  HLYellowCheckerView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLYellowCheckerView.h"

@implementation HLYellowCheckerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setImageViewforCheckerboard {
    
    self.checkerFallenSize = CGSizeMake(self.width/9, self.width/9);
    CGFloat chessleft = self.checkerFallenSize.width/2+4;
    self.rules.checkerboardSize = self.checkerFallenSize;

    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            
            CGPoint point = CGPointMake(0, 0);
           
            //画菱形，设置坐标
            if (i < 5) {
                
                if (j >i) {
                    continue;
                }
                point= CGPointMake(chessleft + i*self.checkerFallenSize.width, (j+2)*self.checkerFallenSize.width);
            } else {
                
                if (j < i) {
                    continue;
                }
                point= CGPointMake(chessleft + i*self.checkerFallenSize.width, (j-4+2)*self.checkerFallenSize.width);
            }
        
            UIImageView *chessFallenImgView = [[[UIImageView alloc] init] normalWithFrame:CGRectMake(0, 0, self.checkerFallenSize.width-4, self.checkerFallenSize.width-4) ImageName:@"棋盘" tag:10*i+j+100];
            
            chessFallenImgView.center = point;
            
            UIImageView *chessmanImgV = [[UIImageView alloc] init];
            [chessmanImgV imageViewForCheckersWithFrame:CGRectMake(0, 0, chessFallenImgView.width-4, chessFallenImgView.width-4) ImageName:@"小黄棋子" tag:10*i+j+200];
            chessmanImgV.center = point;
            chessmanImgV.checkersDelegate = self;
            
            [self addSubview:chessFallenImgView];
            [self.rules.checkerboardMutaArray addObject:@(point)];
            
            if (i == 4 && j == 2) {
                
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
