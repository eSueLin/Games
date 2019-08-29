//
//  HLGreenCheckerView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLGreenCheckerView.h"


@implementation HLGreenCheckerView



- (void)setImageViewforCheckerboard {
    
    self.checkerFallenSize = CGSizeMake((self.width - 8)/8, (self.width-8)/8);
    CGFloat chessPlateLeft = self.checkerFallenSize.width/2+4;
    self.rules.checkerboardSize = self.checkerFallenSize;
    
    for (int i = 0 ; i < 7; i++) {
        for (int j = 0; j < 8; j++) {
           
            if ((i > 1 && i < 5) || (j>2 && j <6)) {
                
                CGFloat pointx = chessPlateLeft+i*self.checkerFallenSize.width;
                CGFloat pointy = j*self.checkerFallenSize.width + 4;
   
                //棋子落下点方格子
                NSInteger chessPlateImgVTag = 10*i+j+100;
                CGRect chessPlateRect = CGRectMake(pointx+2, pointy+2, self.checkerFallenSize.width-4, self.checkerFallenSize.width-4);
                UIImageView *chessPlateImgV = [[[UIImageView alloc] init] normalWithFrame:chessPlateRect
                                                                                ImageName:@"棋盘"
                                                                                      tag:chessPlateImgVTag];
                
                //棋子
                NSInteger chessmanTag = 10*i+j+200;
             
                CGRect chessmanRect = CGRectMake(chessPlateImgV.left+2, chessPlateImgV.top+2, chessPlateImgV.width-4, chessPlateImgV.width-4);
                UIImageView *chessmanImgV = [[[UIImageView alloc] init]   normalWithFrame:chessmanRect ImageName:@"绿棋" tag:chessmanTag];

                
                [self addSubview:chessPlateImgV];
            
                
                if (!self.isHomePage) {
                    [chessmanImgV imageViewForCheckersWithFrame:chessmanRect
                                                      ImageName:@"绿棋"
                                                            tag:chessmanTag];
                    chessmanImgV.checkersDelegate = self;
                    [self.rules.checkerboardMutaArray addObject:@(chessPlateImgV.center)];
                    
                    if (i == 3 && j == 4) {
                        
                        
                        continue;
                    }
                    [self.rules.chessmenMutaArray addObject:chessmanImgV];

                }
                
                if (i == 3 && j == 4) {
                    
                    
                    continue;
                }
                
                [self addSubview:chessmanImgV];
                
            }
        }
    }
//    NSLog(@">>>green:%ld", self.rules.checkerboardMutaArray.count);
//    _checkerRule.chessmenMutaArray = chessmanMutaArr;
//    _checkerRule.checkerboardMutaArray = chessPlatformMutaArr;
//    _checkerRule.checkerboardSize = chessmanSize;
}

- (void)checkersChessmanMoveWithGesture:(UIPanGestureRecognizer *)ges {
    
    [self.rules chessmanMovedWithPanGesture:ges withSurperView:self];
}


@end
