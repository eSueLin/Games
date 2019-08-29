//
//  HLCheckersRules.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLCheckersRules.h"
#import "../HLTool/HLToolbox.h"

@implementation HLCheckersRules
{
    //棋子起始坐标中心位置
    CGFloat firstX;
    CGFloat firstY;
    UIView  *_surperView;
    NSMutableArray *_removedImageViewArr;
    NSInteger moveImageViewTag;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initData];
    }
    return self;
}

- (void)initData {
    
    firstY = 0;
    firstX = 0;
    self.chessmenMutaArray = [NSMutableArray array];
    self.checkerboardMutaArray = [NSMutableArray array];
    _removedImageViewArr = [NSMutableArray array];


}



- (void)chessmanMovedWithPanGesture:(UIPanGestureRecognizer *)pan withSurperView:(nonnull UIView *)surpView{
    
    _surperView = surpView;
    CGPoint translatePoint = [pan translationInView:surpView];
    UIImageView *bImgView = (UIImageView *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        firstX = bImgView.centerX;
        firstY = bImgView.centerY;
    }
    
    translatePoint = CGPointMake(firstX+translatePoint.x, firstY+translatePoint.y);
    bImgView.center = translatePoint;
    moveImageViewTag = bImgView.tag;
    
    [surpView bringSubviewToFront:bImgView];
    
    //容差+棋子落下条件判断
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        BOOL isFoundPoint = NO;
//        NSLog(@"checkerboardSize:%f, %f", self.checkerboardSize.width, self.checkerboardSize.height);

        for (id pfPoint in self.checkerboardMutaArray) {
            
            CGPoint point = [(NSNumber *)pfPoint CGPointValue];
//            NSLog(@">>>>pintY:%f, pointX:%f, imgVx:%f, imgVy:%f", point.y, point.x, bImgView.centerX, bImgView.centerY);
            if (fabs(bImgView.centerX - point.x) < self.checkerboardSize.width/2 && fabs(bImgView.centerY - point.y) < self.checkerboardSize.height/2) {
                
//                NSLog(@"get point:%f,%f",point.x, point.y);
                //相同位置上是否存在棋子
                BOOL isContentChessman = NO;
                for (UIImageView *aimsChessmanView in self.chessmenMutaArray) {
                    
                    //判断相同位置上是否存在棋子
                    //存在棋子,不可以移动到对应位置
                    float pointx = point.x;
                    float pointy = point.y;
                    float aimCenterX = aimsChessmanView.centerX;
                    float aimCenterY = aimsChessmanView.centerY;
                    if (pointx == aimCenterX && pointy == aimCenterY) {
                        
                        isContentChessman = YES;
                        break;
                    }
                }
                
                if (!isContentChessman) {
                    //不存在棋子，判断连线位置棋子情况
                    bImgView.center = point;
                    
                    isFoundPoint = [self checkChessmenOnLineWithFirstPoint:CGPointMake(firstX, firstY) endPoint:point];
                    
                } else {
                    
                    isFoundPoint = NO;
                }
                break;
            }
        }
        
        if (!isFoundPoint) {
            
            bImgView.centerX = firstX;
            bImgView.centerY = firstY;
        }
    }
}

- (BOOL)checkChessmenOnLineWithFirstPoint:(CGPoint)firstPoint endPoint:(CGPoint)endPoint {
    
    float xline = endPoint.x-firstX;
    float yline = endPoint.y-firstY;
    
    float line = xline == 0?yline:xline;
    
    if (self.viewModel == HLGameViewModelTriangle && xline == 0) {
        
        return NO;
    }
    
    if (xline != 0 && yline != 0) {
        
        line = xline;
    }
    
    if (fabs(xline)<fabs(yline)) {
        line = yline;
    }
    
    float checkerboardWidth = self.checkerboardSize.width;
    NSInteger chessmenNum =fabs(sqrtf(powf(xline, 2)+powf(yline, 2)))/checkerboardWidth;
    if (fabs(xline) == fabs(yline)) {
        chessmenNum = fabs(xline)/checkerboardWidth;
    }
    
    NSMutableArray *lineChessmanArr = [NSMutableArray array];
    for (int i = 0; i < chessmenNum-1; i++) {

        CGPoint chessmanPoint = CGPointMake(firstPoint.x+(i+1)*xline/chessmenNum, firstPoint.y+(i+1)*yline/chessmenNum);
        
        for (UIImageView *subChessman in self.chessmenMutaArray) {
            
            float pointy = chessmanPoint.y;
            float chessmanCenterY = subChessman.centerY;
            if (fabs(pointy - chessmanCenterY) < 0.5 ) {
                
                float pointx = chessmanPoint.x;
                float chessmanCenterX = subChessman.centerX;
                if (fabs(pointx -chessmanCenterX) < 0.5) {
                    [lineChessmanArr addObject:subChessman];
                    break;
                }
            }
           
        }
    }
    
    
    if (lineChessmanArr.count > 1 || lineChessmanArr.count == 0) { //存在多个棋子或者没有棋子,不能移动
        
        return NO;
        
    } else {
        //只有一个棋子，判断棋子位置是否在中间
        UIImageView *chessman = lineChessmanArr[0];
        float chessmanCenterX = chessman.centerX;
        float aimChessmanCenterX = firstPoint.x+xline/2;
        float chessmanCenterY = chessman.centerY;
        float aimChessmanCenterY = firstPoint.y+yline/2;
        if (fabs(chessmanCenterX - aimChessmanCenterX) < 0.5  && fabs(chessmanCenterY - aimChessmanCenterY) < 0.5) {
            //中间位置，可以移动
            [chessman removeFromSuperview];
            [self.chessmenMutaArray removeObject:chessman];
            
            NSArray *arr = @[chessman, @(moveImageViewTag), @(firstPoint)];
            [_removedImageViewArr addObject:arr];

            if ([self.delegate respondsToSelector:@selector(checkerRulesRemoveChessmanWithRest:)]) {
                
                [self.delegate checkerRulesRemoveChessmanWithRest:self.chessmenMutaArray.count];
            }
            
            if (self.chessmenMutaArray.count == 1) {
                //闯关成功～～
                if ([self.delegate respondsToSelector:@selector(checkerRulesGameSuceessful)]) {
                    
                    [self.delegate checkerRulesGameSuceessful];
                }
                return YES;
            }
            
            if (self.chessmenMutaArray.count <= 10) {
                
                BOOL isSquare = YES;
                
                if (fabsf(xline) == fabsf(yline)/2 || fabsf(yline) == fabsf(xline)/2) {
                    isSquare = NO;
                }
                
               BOOL isGameOver = [self checkGameOverWithCheckerBoardType:isSquare];
               
                if (isGameOver) {
                    //通知游戏结束
                    if ([self.delegate respondsToSelector:@selector(checkerRulesGameOver)]) {
                        [self.delegate checkerRulesGameOver];
                    }
//                    NSLog(@"isGameOver:%d", isGameOver);
                }
            }
            
            return YES;
            
        } else { //不在中间位置，不能移动
            
            return NO;
        }
    }
}

//遍历每一个棋子上下左右可否跳
- (BOOL)checkGameOverWithCheckerBoardType:(BOOL)isSquare {
    
    if (self.viewModel == HLGameViewModelSquare) {
        
        isSquare = YES;
    } else {
        
        isSquare = NO;
    }
    
    BOOL isGameOver = YES;
    for (int i = 0; i < self.chessmenMutaArray.count; i++) {
        for (int j = 0; j < self.chessmenMutaArray.count; j++) {
            
            //同一个不做对比
            if (i == j) {
                continue;
            }
            
            UIImageView *iImgV = self.chessmenMutaArray[i];
            UIImageView *jImgV = self.chessmenMutaArray[j];
            float distX = [iImgV centerX] - [jImgV centerX];
            float distY = [iImgV centerY] - [jImgV centerY];
            
            //单两个棋子距离大于底view的宽高二分之一,判断不成立
            if (fabs(distX) > _surperView.width/2 || fabs(distY) > _surperView.height/2) {
                continue;
            }
            //两个棋子是否在对称线上
            //两个棋子在对称线上,对称线上分析
            //针对第一关处理，长宽比是1:2
            
            if ((fabs(fabs(distX)-fabs(distY))<0.5 || (distX == 0 && isSquare)|| distY == 0) || (!isSquare && (fabs(fabsf(distX) - fabsf(distY)/2)<0.5 || fabs(fabsf(distY) - fabsf(distX)/2)<0.5))) {
                
                //两个棋子符合以上条件，计算目标位置是否超界
                float aimX = iImgV.centerX - distX*2;
                float aimY = iImgV.centerY - distY*2;
                
                if (aimX < 0 || aimY < 0) {
                    continue;
                }
                
                //判断目标位置上是否存在图片可以移动-->目的：寻找可跳的点
                //目标位置存在图片-->不可移动 ==>判定，同一线上不可以移动
                //     不存在图片-->可以移动 ==>判定，游戏可能没有结束, 进入下一个判断
                BOOL isCanMove = YES;
                for (UIImageView *aimImgV in self.chessmenMutaArray) {
                    
                    if (fabs(aimImgV.centerX - aimX)< 0.5 && fabs(aimY - aimImgV.centerY) < 0.5) {
                        isCanMove = NO;
                        break;
                    }
                }
                if (isCanMove) {

                    //判定目标位置是否超出落点范围 -->目标：可跳的棋盘点
                    //位置不在落点棋盘上 -->不可以移动
                    //     在落点棋盘上 -->可移动
//                    NSLog(@"aimx:%f, aimY:%f", aimX, aimY);
                    BOOL isOverStep = YES;
                    for (NSNumber * obj in self.checkerboardMutaArray) {
                        
                        CGPoint point = [obj CGPointValue];
                        float pointx = point.x;
                        float pointy = point.y;
                        //棋盘上的点于落点一致，可跳
//                        NSLog(@">>>>落点:%f, %f", pointx, pointy);
                        if (fabs(aimX-pointx)<0.5 && fabs(aimY- pointy) < 0.5) {
                            
                            
                            isOverStep = NO;
                            break;
                        }
                    }
                    
                    if (!isOverStep) {
                        
                        isGameOver = NO;
                        break;
                    }
                }
            }
            
        }
        
    }
    
    return isGameOver;
}

- (void)backtoLastStep {
    
    if (_removedImageViewArr.count == 0) {
        return;
    }
    
    NSArray *arr = [_removedImageViewArr lastObject];
    UIImageView *removeImgV = arr[0];
    NSInteger moveTag = [arr[1] integerValue];
    CGPoint point = [arr[2] CGPointValue];
    
    UIImageView *lastImageView = [_surperView viewWithTag:moveTag];
    lastImageView.centerX = point.x;
    lastImageView.centerY = point.y;
    
    [_surperView addSubview:removeImgV];
    
    [_removedImageViewArr removeLastObject];
    [self.chessmenMutaArray addObject:removeImgV];
    
    if ([self.delegate respondsToSelector:@selector(checkerRulesRemoveChessmanWithRest:)]) {
        
        [self.delegate checkerRulesRemoveChessmanWithRest:self.chessmenMutaArray.count];
    }
    
}
@end
