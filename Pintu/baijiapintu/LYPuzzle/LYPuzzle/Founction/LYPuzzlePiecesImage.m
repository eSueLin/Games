//
//  LYPuzzlePiecesImage.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/17.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYPuzzlePiecesImage.h"
#import <CoreGraphics/CoreGraphics.h>
#import "Toolbox.h"

@interface LYPuzzlePiecesImage()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSUInteger pieceHCount;

@property (nonatomic, assign) NSUInteger pieceVCount;

@property (nonatomic, assign) NSInteger cubeHeightValue;

@property (nonatomic, assign) NSInteger cubeWidthValue;

@property (nonatomic, assign) NSInteger deepnessH;

@property (nonatomic, assign) NSInteger deepnessV;

@property (nonatomic, strong) UIImage   *originalImage;

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UIView *surperView;

/** 切片类型数组 **/
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pieceTypeArray;

/** 切片坐标 **/
@property (nonatomic, strong) NSMutableArray *pieceCoordonateRectArray;

/** 切片方向 **/
@property (nonatomic, strong) NSMutableArray *pieceRotationArray;

/** 完整贝塞尔曲线(切片) **/
@property (nonatomic, strong) NSMutableArray *pieceBezierPathsArray;

@property (nonatomic, strong) NSMutableArray *pointCorrectArr;

/** 图片移动的起始位置 **/
@property (assign) CGFloat firstX;
@property (assign) CGFloat firstY;


@end

@implementation LYPuzzlePiecesImage
{
    
}

- (instancetype)initPuzzlePiecesWithImage:(NSString *)imageName tipsView:(UIImageView *)imgView
{
    self = [super init];
    if (self) {
    
        [self initDataWithImageName:imageName tipsImageView:imgView];
    }
    return self;
}

- (void)initDataWithImageName:(NSString *)imageName tipsImageView:(UIImageView *)imgV {
    
    self.tipImageView = imgV;
    
    self.originalImage = [self imageResetforSize:[UIImage imageNamed:imageName] toTargetSize:imgV.frame.size];
    
 
    //初始化数组
    self.pieceTypeArray = [NSMutableArray array];
    self.pointCorrectArr = [NSMutableArray array];
    self.pieceRotationArray = [NSMutableArray array];
    self.pieceImageViewsArray = [NSMutableArray array];
    self.pieceBezierPathsArray = [NSMutableArray array];
    self.pieceCoordonateRectArray = [NSMutableArray array];
}

- (void)resetData {

    [self removeAllPiece];
}

-(void)removeAllPiece {
    
    for (UIImageView *imgV in _pieceImageViewsArray) {
        
        [imgV removeFromSuperview];
    }
}

- (void)startSliceWithSuperView:(UIView *)surpView {
    
    self.pieceHCount = self.pieceLevel;
    self.pieceVCount = self.pieceLevel;
    
    //切块尺寸
    self.cubeWidthValue  = self.originalImage.size.height/self.pieceHCount;
    self.cubeHeightValue = self.originalImage.size.width/self.pieceVCount;
    
    //凹凸深度
    self.deepnessH = -(self.cubeHeightValue/4);
    self.deepnessV = -(self.cubeWidthValue/4);
    
    [self setUpPieceWithPieceTypePCoodinateAndPRotationArr];
    [self setupBezierPath];
    [self addPuzzleImageswithSurperView:surpView];
    
    self.surperView = surpView;
}

- (void)setUpPieceWithPieceTypePCoodinateAndPRotationArr {
    
    NSUInteger iCounter = 0;
    
    PieceType iSideLeft   = PieceTypeEmpty;
    PieceType iSideBottom = PieceTypeEmpty;
    PieceType iSideRight  = PieceTypeEmpty;
    PieceType iSideTop    = PieceTypeEmpty;
    
    NSUInteger iCubeWidth = 0;
    NSUInteger iCubeHeight = 0;
    
    //i为垂直方向，j为水平方向
      for (int i = 0; i < self.pieceVCount; i++) {
        for (int j = 0; j < self.pieceHCount; j++) {
            
            //根据随机生成的凹凸边，设置契合的对应边线（凹凸）
            if (0 != j) {
                
                iSideLeft = [[[self.pieceTypeArray objectAtIndex:iCounter-1] objectForKey:@(PieceSideTypeRight)] intValue] == PieceTypeOutside?PieceTypeInside:PieceTypeOutside;
            }
            
            if (0 != i) {
                
                iSideTop = [self.pieceTypeArray[iCounter-self.pieceHCount][@(PieceSideTypeBottom)] intValue] == PieceTypeOutside?PieceTypeInside:PieceTypeOutside;
            }
            
            //随机凹凸边
            iSideBottom = arc4random()%2 == 1?PieceTypeOutside:PieceTypeInside;
            iSideRight  = arc4random()%2 == 1?PieceTypeOutside:PieceTypeInside;
            
            //设置整图边（平整，不需要凹凸）
            if (0 == i) {
                iSideTop = PieceTypeEmpty;
            }
            if (0 == j) {
                iSideLeft = PieceTypeEmpty;
            }
            if (self.pieceVCount-1 == i) {
                iSideBottom = PieceTypeEmpty;
            }
            if (self.pieceHCount-1 == j) {
                iSideRight = PieceTypeEmpty;
            }
            
            //设置拼块高度以及宽度
            iCubeWidth = self.cubeWidthValue;
            iCubeHeight = self.cubeHeightValue;
            
            //根据凹凸情况，修正对应画宽高
            if (iSideLeft == PieceTypeOutside) {
                
                iCubeWidth -= self.deepnessV;
            }
            if (iSideRight == PieceTypeOutside) {
                iCubeWidth -= self.deepnessV;
            }
            if (iSideBottom == PieceTypeOutside) {
                iCubeHeight -= self.deepnessH;
            }
            if (iSideTop == PieceTypeOutside) {
                iCubeHeight -= self.deepnessH;
            }
            
            NSMutableDictionary *iOnePieceDic = [NSMutableDictionary dictionary];
            
            [iOnePieceDic setObject:@(iSideLeft) forKey:@(PieceSideTypeLeft)];
            [iOnePieceDic setObject:@(iSideRight) forKey:@(PieceSideTypeRight)];
            [iOnePieceDic setObject:@(iSideTop) forKey:@(PieceSideTypeTop)];
            [iOnePieceDic setObject:@(iSideBottom) forKey:@(PieceSideTypeBottom)];
            
            [self.pieceTypeArray addObject:iOnePieceDic];
            
            //裁剪和图像用的frame和bouns
            CGFloat iStartPointX = self.tipImageView.left;
            CGFloat iStartPointY = self.tipImageView.top;
            [self.pieceCoordonateRectArray addObject:[NSArray arrayWithObjects:
                                                      @(CGRectMake(j*self.cubeWidthValue, i*self.cubeHeightValue, iCubeWidth, iCubeHeight)),
                                                      @(CGRectMake(iStartPointX+j*self.cubeWidthValue-(iSideLeft == PieceTypeOutside?-self.deepnessV:0), iStartPointY+i*self.cubeHeightValue-(iSideTop == PieceTypeOutside?-self.deepnessH:0), iCubeWidth, iCubeHeight)), nil]];
            
            [self.pieceRotationArray addObject:[NSNumber numberWithFloat:0]];
            iCounter++;
        }
    }
    
}

- (void)setupBezierPath {
    
    float iYSideStartPos = 0;
    float iXSideStartPos = 0;
    float iCustomDeepness = 0;
    float iCurveHalfVLength = self.cubeWidthValue/10;
    float iCurveHalfHLength = self.cubeHeightValue/10;
    float iCurveStartXPos   = self.cubeWidthValue/2-iCurveHalfVLength;
    float iCurveStartYPos   = self.cubeHeightValue/2-iCurveHalfHLength;
    float iTotalHeight = 0; //总高
    float iTotalWidth  = 0; //总宽
    
    for (int i = 0; i < self.pieceTypeArray.count; i++) {
        
        iXSideStartPos = [[self.pieceTypeArray[i] objectForKey:@(PieceSideTypeLeft)] integerValue] == PieceTypeOutside?-self.deepnessV:0;
        iYSideStartPos = [[self.pieceTypeArray[i] objectForKey:@(PieceSideTypeTop)] integerValue] == PieceTypeOutside?-self.deepnessH:0;
        
        iTotalHeight = iYSideStartPos + iCurveStartYPos*2 + iCurveHalfHLength*2;
        iTotalWidth  = iXSideStartPos + iCurveStartXPos*2 + iCurveHalfVLength*2;
        
        UIBezierPath *iPieceBezier = [UIBezierPath bezierPath];
        [iPieceBezier moveToPoint:CGPointMake(iXSideStartPos, iYSideStartPos)];
        
        [iPieceBezier addLineToPoint:CGPointMake(iXSideStartPos, iYSideStartPos+iCurveStartYPos)];
        
        if ([self.pieceTypeArray[i][@(PieceSideTypeLeft)] integerValue] != PieceTypeEmpty) {
            
            iCustomDeepness = self.deepnessV * [self.pieceTypeArray[i][@(PieceSideTypeLeft)] intValue];
            
            [iPieceBezier addCurveToPoint:CGPointMake(iXSideStartPos+iCustomDeepness, iYSideStartPos+iCurveStartYPos+iCurveHalfHLength)
                            controlPoint1:CGPointMake(iXSideStartPos, iYSideStartPos+iCurveStartYPos)
                            controlPoint2:CGPointMake(iXSideStartPos+iCustomDeepness, iYSideStartPos+iCurveStartYPos+iCurveHalfHLength-iCurveStartYPos)];
            
            [iPieceBezier addCurveToPoint:CGPointMake(iXSideStartPos, iYSideStartPos+iCurveStartXPos+iCurveHalfHLength*2)
                            controlPoint1:CGPointMake(iXSideStartPos+iCustomDeepness, iYSideStartPos+iCurveStartYPos+iCurveHalfHLength+iCurveStartYPos)
                            controlPoint2:CGPointMake(iXSideStartPos, iYSideStartPos+iCurveStartYPos+iCurveHalfHLength*2)];
        }
        
        [iPieceBezier addLineToPoint:CGPointMake(iXSideStartPos, iTotalHeight)];
        
        [iPieceBezier addLineToPoint:CGPointMake(iXSideStartPos+iCurveStartXPos, iTotalHeight)];
        
        if ([self.pieceTypeArray[i][@(PieceSideTypeBottom)] intValue] != PieceTypeEmpty) {
            
            iCustomDeepness = self.deepnessH * [self.pieceTypeArray[i][@(PieceSideTypeBottom)] intValue];
            
            [iPieceBezier addCurveToPoint:CGPointMake(iXSideStartPos+iCurveStartXPos+iCurveHalfVLength, iTotalHeight-iCustomDeepness)
                            controlPoint1:CGPointMake(iXSideStartPos+iCurveStartXPos, iTotalHeight)
                            controlPoint2:CGPointMake(iXSideStartPos+iCurveHalfVLength, iTotalHeight-iCustomDeepness)];
            
            [iPieceBezier addCurveToPoint:CGPointMake(iXSideStartPos+iCurveStartXPos+iCurveHalfVLength+iCurveHalfVLength, iTotalHeight)
                            controlPoint1:CGPointMake(iTotalWidth-iCurveHalfVLength, iTotalHeight-iCustomDeepness)
                            controlPoint2:CGPointMake(iXSideStartPos+iCurveStartXPos+iCurveHalfVLength+iCurveHalfVLength, iTotalHeight)];
        }
        
        [iPieceBezier addLineToPoint:CGPointMake(iTotalWidth, iTotalHeight)];
        
        [iPieceBezier addLineToPoint:CGPointMake(iTotalWidth, iTotalHeight-iCurveStartYPos)];
        if ([self.pieceTypeArray[i][@(PieceSideTypeRight)] intValue] != PieceTypeEmpty) {
            
            iCustomDeepness = self.deepnessV * [self.pieceTypeArray[i][@(PieceSideTypeRight)] intValue];
            
            [iPieceBezier addCurveToPoint: CGPointMake(iTotalWidth - iCustomDeepness, iYSideStartPos + iCurveStartYPos + iCurveHalfHLength)
                            controlPoint1: CGPointMake(iTotalWidth, iYSideStartPos + iCurveStartYPos + iCurveHalfHLength * 2)
                            controlPoint2: CGPointMake(iTotalWidth - iCustomDeepness, iTotalHeight - iCurveHalfHLength)];
            
            [iPieceBezier addCurveToPoint: CGPointMake(iTotalWidth, iYSideStartPos + iCurveStartYPos)
                            controlPoint1: CGPointMake(iTotalWidth - iCustomDeepness, iYSideStartPos + iCurveHalfHLength)
                            controlPoint2: CGPointMake(iTotalWidth, iCurveStartYPos + iYSideStartPos)];
        }
        
        [iPieceBezier addLineToPoint: CGPointMake(iTotalWidth, iYSideStartPos)];
        
        
        //2.2.3 绘制PieceSideTypeTop
        [iPieceBezier addLineToPoint: CGPointMake(iTotalWidth - iCurveStartXPos, iYSideStartPos)];
        if([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] integerValue] != PieceTypeEmpty) {
            iCustomDeepness = self.deepnessH * [[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] intValue];
            
            [iPieceBezier addCurveToPoint: CGPointMake(iTotalWidth - iCurveStartXPos - iCurveHalfVLength, iYSideStartPos + iCustomDeepness)
                            controlPoint1: CGPointMake(iTotalWidth - iCurveStartXPos, iYSideStartPos)
                            controlPoint2: CGPointMake(iTotalWidth - iCurveHalfVLength, iYSideStartPos + iCustomDeepness)];
            
            [iPieceBezier addCurveToPoint: CGPointMake(iXSideStartPos + iCurveStartXPos, iYSideStartPos)
                            controlPoint1: CGPointMake(iXSideStartPos + iCurveHalfVLength, iYSideStartPos + iCustomDeepness)
                            controlPoint2: CGPointMake(iXSideStartPos + iCurveStartXPos, iYSideStartPos)];
        }
        
        [iPieceBezier addLineToPoint: CGPointMake(iXSideStartPos, iYSideStartPos)];
        
        [self.pieceBezierPathsArray addObject:iPieceBezier];
    }
}

- (void)addPuzzleImageswithSurperView:(id)surpView {
    
    float mXAddableVal = 0;
    float mYAddableVal = 0;
    
    for(int i = 0; i < [self.pieceBezierPathsArray count]; i++) {
        CGRect mCropFrame = [[[self.pieceCoordonateRectArray objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[self.pieceCoordonateRectArray objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
        // 切割图片.
        UIImageView *mPeace = [UIImageView new];
        [mPeace setFrame:mImageFrame];
        [mPeace setTag:i+100];
        [mPeace setUserInteractionEnabled:YES];
        [mPeace setContentMode:UIViewContentModeTopLeft];
        
        // 修正
        mXAddableVal = ([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeLeft)] integerValue] == PieceTypeOutside)?self.deepnessV:0;
        mYAddableVal = ([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] integerValue] == PieceTypeOutside)?self.deepnessH:0;
        mCropFrame.origin.x += mXAddableVal;
        mCropFrame.origin.y += mYAddableVal;
        
        
        // 添加图片
        [mPeace setImage:[self cropImage:self.originalImage withRect:mCropFrame]];
        [self setClippingPath:[self.pieceBezierPathsArray objectAtIndex:i]:mPeace];
        [surpView addSubview:mPeace];
        [mPeace setTransform:CGAffineTransformMakeRotation([[self.pieceRotationArray objectAtIndex:i] floatValue])];
        
        
        // 设置layer 已经边缘线条
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        [mBorderPathLayer setPath:[[self.pieceBezierPathsArray objectAtIndex:i] CGPath]];
        [mBorderPathLayer setFillColor:[UIColor clearColor].CGColor];
        [mBorderPathLayer setStrokeColor:[UIColor blackColor].CGColor];
        [mBorderPathLayer setLineWidth:1];
        [mBorderPathLayer setFrame:CGRectZero];
        [[mPeace layer] addSublayer:mBorderPathLayer];
        
        // 添加手势
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMaximumNumberOfTouches:2];
        [panRecognizer setDelegate:self];
        [mPeace addGestureRecognizer:panRecognizer];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tapGesture setDelegate:self];
        [mPeace addGestureRecognizer:tapGesture];
        
        [_pieceImageViewsArray addObject:mPeace];
    }
}

- (void)setClippingPath:(UIBezierPath *)clippingPath : (UIImageView *)imgView {
    if (![[imgView layer] mask]){
        [[imgView layer] setMask:[CAShapeLayer layer]];
    }
    [(CAShapeLayer*) [[imgView layer] mask] setPath:[clippingPath CGPath]];
}

- (UIImage *)cropImage:(UIImage*)originalImage withRect:(CGRect)rect {
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rect)];
}

- (UIImage *)imageResetforSize:(UIImage *)orgImg toTargetSize:(CGSize)aSize {
    
    UIImage *newImage;
    
    if (nil == orgImg) {
        newImage = nil;
    } else {
        
        CGSize orgSize = orgImg.size;
        CGRect rect;
        if (aSize.width/aSize.height > orgSize.width/orgSize.height) {
            
            rect.size.width  = aSize.height*orgSize.width/orgSize.height;
            rect.size.height = aSize.height;
            rect.origin.x    = (aSize.width - rect.size.width)/2;
            rect.origin.y    = 0;
        } else {
            
            rect.size.width  = aSize.width;
            rect.size.height = aSize.width*orgSize.height/orgSize.width;
            rect.origin.x    = 0;
            rect.origin.y    = (aSize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(aSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        UIRectFill(CGRectMake(0, 0, aSize.width, aSize.height));
        
        [orgImg drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newImage;
    
}

#pragma mark - about gesture
static const CGFloat kVerificationTolerance = 8.0; // 验证容错值
- (void)move:(UIPanGestureRecognizer *)sender {
    
    //图片移动
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:_surperView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.firstX = sender.view.center.x;
        self.firstY = sender.view.center.y;
        NSLog(@"firstX:%f, firstY:%f", self.firstX, self.firstY);
    }
    UIImageView *mImgView = (UIImageView *)sender.view;
    translatedPoint = CGPointMake(self.firstX+translatedPoint.x, self.firstY+translatedPoint.y);
    [mImgView setCenter:translatedPoint];

    [self.surperView bringSubviewToFront:mImgView];
    
    
    // 验证相关
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGRect mImageFrame = [[[self.pieceCoordonateRectArray objectAtIndex:mImgView.tag-100] objectAtIndex:1] CGRectValue];
        CGPoint mimagePoint = CGPointMake(mImageFrame.origin.x +mImageFrame.size.width/2, mImageFrame.origin.y + mImageFrame.size.height/2);
        if ( fabs(mimagePoint.x - mImgView.center.x) <= kVerificationTolerance &&
            fabs(mimagePoint.y - mImgView.center.y) <= kVerificationTolerance) {
            NSLog(@"位置匹配，可以修正");
            [mImgView setCenter:mimagePoint];
            //数组存储配置好的模块，判断是否重复情况，判断是否拼接完成
            
            for (NSNumber *point in _pointCorrectArr) {
                
                if (point.CGPointValue.x == mimagePoint.x && point.CGPointValue.y == mimagePoint.y) {
                    
                    NSLog(@"位置匹配成功过，不需要重新加入");
                    return;
                }
            }
            [_pointCorrectArr addObject:@(mimagePoint)];
            
            //判断当前是否完成
            if (_pointCorrectArr.count == self.pieceLevel*self.pieceLevel) {
                
                //                [_timerView timerStop];
                //                [[BYGameCenterInt gameCenter] reportResultScore:_timerView.usedTime leaderBoard:(int)_level];
                
                if ([self.delegate respondsToSelector:@selector(puzzleImagesMovetoTargetFrameFinishedWithObject:)]) {
                    
                    [self.delegate puzzleImagesMovetoTargetFrameFinishedWithObject:@(self.pieceLevel)];
                }
            }
            
        }else{
            
            NSNumber *sbPoint;
            BOOL isRemove = NO;
            for (NSNumber *point in _pointCorrectArr) {
                
                if (point.CGPointValue.x == mimagePoint.x && point.CGPointValue.y == mimagePoint.y) {
                    
                    //已完成的mo块被移除，删除数组中c成功的块
                    sbPoint = point;
                    isRemove = YES;
                    
                }
            }
            
            if (isRemove) {
                [_pointCorrectArr removeObject:sbPoint];
            }
            NSLog(@"位置不匹配，%@--- %@",NSStringFromCGPoint(mimagePoint),NSStringFromCGPoint(translatedPoint));
        }
    }
}

- (void)tap:(UIGestureRecognizer *)sender {
    
    
}

/** gesture delegete **/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([self.delegate respondsToSelector:@selector(puzzleImagesGestureReconizeDelegateRespondWithGesture:receiveTouch:)]) {
        [self.delegate puzzleImagesGestureReconizeDelegateRespondWithGesture:gestureRecognizer receiveTouch:touch];
    }
    
    return YES;
}

@end
