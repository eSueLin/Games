//
//  HLWhiteView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/29.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLWhiteCheckerView.h"
#define ScreenWith [UIScreen mainScreen].bounds.size.width

@implementation HLWhiteCheckerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageViewforCheckerboard {
    
    self.checkerFallenSize = CGSizeMake(self.width/8, self.width/8);
    self.rules.checkerboardSize = self.checkerFallenSize;
    
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 2*i+1; j++) {
            
            CGPoint point = CGPointMake(0, 0);
            
           
            if (i < 4) {
                 point = CGPointMake(ScreenWith/2+(j-i)*self.checkerFallenSize.width, i*self.checkerFallenSize.width+self.checkerFallenSize.height/2);
            } else {  //i>4 画倒三角
                if (j >= (7-i)*2-1 ) {
                    continue;
                }
                 point = CGPointMake(ScreenWith/2+(j-(7-i-1))*self.checkerFallenSize.width, i*self.checkerFallenSize.width+self.checkerFallenSize.height/2);
            }
            
            UIImageView *chessFallenImgView = [[[UIImageView alloc] init] normalWithFrame:CGRectMake(0, 0, self.checkerFallenSize.width-10, self.checkerFallenSize.width-10) ImageName:@"棋盘" tag:10*i+j+100];
            
            chessFallenImgView.center = point;
            
            UIImageView *chessmanImgV = [[UIImageView alloc] init];
            [chessmanImgV imageViewForCheckersWithFrame:CGRectMake(0, 0, chessFallenImgView.width-4, chessFallenImgView.width-4) ImageName:@"白色棋子" tag:10*i+j+200];
            chessmanImgV.center = point;
            chessmanImgV.checkersDelegate = self;
            
            [self addSubview:chessFallenImgView];
            [self.rules.checkerboardMutaArray addObject:@(point)];
            
            if (i == 3 && j == 3) {
                
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
