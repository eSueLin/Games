//
//  HLBlueCheckerView.m
//  HLCheckers
//
//  Created by HC16 on 2019/5/5.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLBlueCheckerView.h"

@implementation HLBlueCheckerView

- (void)setImageViewforCheckerboard {
    
    self.checkerFallenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/9, [UIScreen mainScreen].bounds.size.width/9);
    self.rules.checkerboardSize = self.checkerFallenSize;
    
    for (int i = 0; i < 8; i++) {
        
        if (0 == i) {
            
            for (int t = 0; t < 2; t++) {
                CGPoint point = CGPointMake(0, 0);
                float distx = ((float)t-(float)(i+2)/2)*self.checkerFallenSize.width+ScreenWith/2;
//                NSLog(@"%f", distx);
                point = CGPointMake(distx, self.checkerFallenSize.height*(i+1));
                
                [self createCheckersWithPoint:point withX:i y:t];
            }
            continue;
        }
        
        if (6 == i) {

            for (int k = 0; k < i+2; k++) {

                CGPoint point = CGPointMake(0, 0);
                point = CGPointMake(ScreenWith/2+((float)k-(i+2)/2)*self.checkerFallenSize.width, self.checkerFallenSize.height*(i+1));

                [self createCheckersWithPoint:point withX:i y:k];
            }

            continue;
        }
        
        
        for (int j = 0; j < i; j++) {
            
            if ((i == 7 && j>0 && j < 6)) {
                continue;
            }
            
            CGPoint point = CGPointMake(0, 0);
            point = CGPointMake(ScreenWith/2+(j-(CGFloat)i/2)*self.checkerFallenSize.width, self.checkerFallenSize.height*(i+1));
            
            [self createCheckersWithPoint:point withX:i y:j];

        }
    }
}

- (void)createCheckersWithPoint:(CGPoint)point withX:(int)i y:(int)t{
    
    UIImageView *checkerboardImgV = [[[UIImageView alloc] init] normalWithFrame:CGRectMake(point.x, point.y, self.checkerFallenSize.width-4, self.checkerFallenSize.width-4) ImageName:@"棋盘" tag:self.rules.chessmenMutaArray.count+100];
    checkerboardImgV.center = point;
    
    UIImageView *chessmanImgV = [[UIImageView alloc] init];
    [chessmanImgV imageViewForCheckersWithFrame:CGRectMake(0, 0, checkerboardImgV.width-4, checkerboardImgV.width-4) ImageName:@"蓝色棋子" tag:self.rules.chessmenMutaArray.count+200];
    chessmanImgV.center = point;
    chessmanImgV.checkersDelegate = self;
    
    [self.rules.checkerboardMutaArray addObject:@(point)];
    
    [self addSubview:checkerboardImgV];
    if (i == 3 && t == 1) {
        
        [chessmanImgV removeFromSuperview];
        return;
    }
    [self.rules.chessmenMutaArray addObject:chessmanImgV];
    [self addSubview:chessmanImgV];
}

- (void)checkersChessmanMoveWithGesture:(UIPanGestureRecognizer *)ges {
    
    [self.rules chessmanMovedWithPanGesture:ges withSurperView:self];
}

@end
