//
//  HLOrangeCheckerView.m
//  HLCheckers
//
//  Created by HC16 on 2019/5/5.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLOrangeCheckerView.h"

@implementation HLOrangeCheckerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageViewforCheckerboard {
    
    self.checkerFallenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/9, [UIScreen mainScreen].bounds.size.width/9);
    self.rules.checkerboardSize = self.checkerFallenSize;
    
    for (int i = 0; i < 7; i++) {
        
        int k = i+4;
        if (i >= 4) {
            
            k = 7-(i+1)+4;
        }
        for (int j = 0; j < k; j++) {
            
            CGPoint point = CGPointMake(0, 0);
            point = CGPointMake(ScreenWith/2+(j-(CGFloat)k/2)*self.checkerFallenSize.width, self.checkerFallenSize.height*(i+1));
            
            [self createCheckersWithPoint:point withX:i y:j];
        }
    }
}

- (void)createCheckersWithPoint:(CGPoint)point withX:(int)i y:(int)t{
    
    UIImageView *checkerboardImgV = [[[UIImageView alloc] init] normalWithFrame:CGRectMake(point.x, point.y, self.checkerFallenSize.width-4, self.checkerFallenSize.width-4) ImageName:@"棋盘" tag:self.rules.chessmenMutaArray.count+100];
    checkerboardImgV.center = point;
    
    UIImageView *chessmanImgV = [[UIImageView alloc] init];
    [chessmanImgV imageViewForCheckersWithFrame:CGRectMake(0, 0, checkerboardImgV.width-4, checkerboardImgV.width-4) ImageName:@"黄色棋子" tag:self.rules.chessmenMutaArray.count+200];
    chessmanImgV.center = point;
    chessmanImgV.checkersDelegate = self;
    
    [self.rules.checkerboardMutaArray addObject:@(point)];
    
    [self addSubview:checkerboardImgV];
    if (i == 3 && t == 3) {
        
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
