//
//  ViewController.m
//  BMPintu
//
//  Created by BirdMichael on 2019/4/14.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BYPtuViewController.h"
#import "UIView+Additions.h"
#import "UIButton+Additions.h"
#import "BYTimer.h"
#import "BYShadowBGView.h"
#import "FouctionView/BYGameCenterInt.h"
#import "FouctionView/MPFailedView.h"
#import "FouctionView/MPSuccessView.h"

#define SCREEN_RADIO [[UIScreen mainScreen] bounds].size.height/896

static const CGFloat kVerificationTolerance = 8.0; // 验证容错值

typedef NS_ENUM(NSInteger, PieceType) {
    PieceTypeInside = -1,  // 凸
    PieceTypeEmpty, // 空（即边缘平整类型）
    PieceTypeOutside, // 凹
};
typedef NS_ENUM(NSInteger, PieceSideType) {
    PieceSideTypeLeft,
    PieceSideTypeBottom,
    PieceSideTypeRight,
    PieceSideTypeTop,
    PieceSideTypeCount // 占位索引
};

@interface BYPtuViewController () <UIGestureRecognizerDelegate, MPTipViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButtom;

// 原始图片
@property (nonatomic, strong) UIImage *originalCatImage;
/** 水平切片数量 */
@property (nonatomic, assign) NSUInteger pieceHCount;
/** 垂直切片数量 */
@property (nonatomic, assign) NSUInteger pieceVCount;
/** 方格模块高度值 */
@property (nonatomic, assign) NSInteger cubeHeightValue;
/** 方格模块宽度值 */
@property (nonatomic, assign) NSInteger cubeWidthValue;
/** 水平深度 */
@property (nonatomic, assign) NSInteger deepnessH;
/** 垂直深度 */
@property (nonatomic, assign) NSInteger deepnessV;

/** 切片类型数组 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pieceTypeArray;
/** 切片坐标 */
@property (nonatomic, strong) NSMutableArray *pieceCoordinateRectArray;
/** 切片坐标 */
//@property (nonatomic, strong) NSMutableArray *pieceCoordinateBoundsArray;
/** 切片方向 */
@property (nonatomic, strong) NSMutableArray *pieceRotationArray;

/** 切片完整贝塞尔曲线 */
@property (nonatomic, strong) NSMutableArray *pieceBezierPathsArray;

/** 切片 **/
@property (nonatomic, strong) NSMutableArray *pieceImagesArray;
@property (nonatomic, strong) NSMutableArray *pieceImageViewsArray;

@property (nonatomic, assign) CGFloat firstX;
@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, strong) UIImageView *tipsImgaeView;

/** 统计拼图匹配完成块 **/
@property (nonatomic, strong) NSMutableArray *pointCorrectArr;

/** 后退返回上一层 **/
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation BYPtuViewController
{
    BYTimer * _timerView;
    NSString * _randImageName;
    BYShadowBGView * _bgView;
}

static bool _couldTouchImage = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(initAll) withObject:nil afterDelay:0.1];
    _couldTouchImage = YES;
}

- (void)initAll {
    [self setInitData];
    [self initializeDataSet];
    [self setupPieceTypePieceCoordinateAndRotationValuesArrays];
    [self setUpPieceBezierPaths];
    [self setUpPuzzlePieceImages];
    
    [self setTimer];
}

- (void)setTimer {

    NSArray *arr = @[@"30", @"60", @"120"];
    self.timeCountLabel.text = arr[self.level-1];
    _timerView = [[BYTimer alloc] init];
    [_timerView setCountdownTime:self.timeCountLabel.text.intValue];
    [_timerView timerStart];
    __block  typeof(self)  ptuVC=self;
    _timerView.tblock = ^(int time) {
        
        ptuVC.timeCountLabel.text = [NSString stringWithFormat:@"%d", time];
        if (0 == time) {
            
            //时间到，游戏结束，tip fail
            MPFailedView *failed = (MPFailedView *)[[[NSBundle mainBundle] loadNibNamed:@"MPFailedView" owner:nil options:nil] firstObject];
            failed.frame = ptuVC.view.frame;
            failed.delegate = ptuVC;
            _couldTouchImage = NO;
            [ptuVC.view.window addSubview:failed];
        }
    };
}

#pragma mark ——— 私有方法

-  (void)setInitData{
    
    self.pointCorrectArr = [NSMutableArray array];
    [self getRandPintuImage];
}


- (void)setNewTimer{
    
    [_timerView timerStart];
}

- (void)showTip {
    self.tipsImgaeView.image = [UIImage imageNamed:_randImageName];
    self.tipsImgaeView.alpha = 0.5;
}
- (void)hideTip {
    self.tipsImgaeView.image = nil;
    self.tipsImgaeView.alpha = 1;
}

/** 随机获取图片名字 **/
- (void)getRandPintuImage {
    
    _randImageName = [NSString stringWithFormat:@"image%ld", (long)self.level];
}

/** 设置初始化数据 */
- (void)initializeDataSet {
    //创建提示图像，（位置以及尺寸决定拼图位置以及尺寸）
    UIImage *image = [UIImage imageNamed:_randImageName];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tipsImgaeView = [UIImageView new];
    self.tipsImgaeView.size = CGSizeMake(image.size.width*2/3*SCREEN_RADIO, image.size.height*2/3*SCREEN_RADIO);
    self.tipsImgaeView.centerX = [[UIScreen mainScreen] bounds].size.width/2;
    self.tipsImgaeView.top = self.timeCountLabel.bottom+10;

    
    self.originalCatImage = [self imageResize:image andResizeTo:self.tipsImgaeView.frame.size];
    
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"game_bottom%ld", (long)self.level]]];

    bottomView.frame = self.tipsImgaeView.frame;
    bottomView.size = CGSizeMake(bottomView.width+1.5, bottomView.height-0.5);
    bottomView.centerX = self.tipsImgaeView.centerX;
    bottomView.centerY = self.tipsImgaeView.centerY-1;
    [self.view addSubview:bottomView];
    [self.view addSubview:self.tipsImgaeView];

    // 切片数量
    self.pieceHCount = _level+2;
    self.pieceVCount = _level+2;
    // 切片尺寸
    self.cubeHeightValue = self.originalCatImage.size.height/self.pieceVCount;
    self.cubeWidthValue = self.originalCatImage.size.width/self.pieceHCount;
    // 设置深度（凹凸。支出去多少）
    self.deepnessH = -(self.cubeHeightValue / 4);
    self.deepnessV = -(self.cubeWidthValue / 4);
    
    // 初始化组数容器
    self.pieceTypeArray = [@[] mutableCopy];
    self.pieceCoordinateRectArray = [@[] mutableCopy];
//    self.pieceCoordinateBoundsArray = [@[] mutableCopy];
    self.pieceRotationArray = [@[] mutableCopy];
    self.pieceBezierPathsArray = [@[] mutableCopy];
    
}

/** 设置Piece切片的类型，坐标，以及方向 */
- (void)setupPieceTypePieceCoordinateAndRotationValuesArrays {
    
    NSUInteger mCounter = 0; // 调用次数计数器
    
    PieceType mSideL = PieceTypeEmpty;
    PieceType mSideB = PieceTypeEmpty;
    PieceType mSideR = PieceTypeEmpty;
    PieceType mSideT = PieceTypeEmpty;
    
    NSUInteger mCubeWidth = 0;
    NSUInteger mCubeHeight = 0;
    
    // 构建2维 i为垂直，j为水平
    for(int i = 0; i < self.pieceVCount; i++) {
        for(int j = 0; j < self.pieceHCount; j++) {
            // 1.设置类型
            
            // 1.1 中间 保证一凸一凹
            if(j != 0) {
                mSideL = ([[[self.pieceTypeArray objectAtIndex:mCounter-1] objectForKey:@(PieceSideTypeRight)] intValue] == PieceTypeOutside)?PieceTypeInside:PieceTypeOutside;
            }
            if(i != 0){
                mSideT = ([[[self.pieceTypeArray objectAtIndex:mCounter-self.pieceHCount] objectForKey:@(PieceSideTypeBottom)] intValue] == PieceTypeOutside)?PieceTypeInside:PieceTypeOutside;
            }
            // 随机凹凸
            mSideB = ((arc4random() % 2) == 1)?PieceTypeOutside:PieceTypeInside;
            mSideR = ((arc4random() % 2) == 1)?PieceTypeOutside:PieceTypeInside;
            
            // 1.2 边
//            if(i == 0) {
                mSideT = PieceTypeEmpty;
//            }
//            if(j == 0) {
                mSideL = PieceTypeEmpty;
//            }
//            if(i == self.pieceVCount-1) {
                mSideB = PieceTypeEmpty;
//            }
//            if(j == self.pieceHCount - 1) {
                mSideR = PieceTypeEmpty;
//            }
            
            // 2.设置高度以及宽度
            // 2.1 重置数据
            mCubeWidth = self.cubeWidthValue;
            mCubeHeight = self.cubeHeightValue;
            // 2.2 根据凹凸 进行数据修正，减去凹部分
//            if(mSideL == PieceTypeOutside) {
//                mCubeWidth -= self.deepnessV;
//            }
//            if(mSideR == PieceTypeOutside) {
//                mCubeWidth -= self.deepnessV;
//            }
//            if(mSideB == PieceTypeOutside) {
//                mCubeHeight -= self.deepnessH;
//            }
//            if(mSideT == PieceTypeOutside) {
//                mCubeHeight -= self.deepnessH;
//            }
            
            // 3. 组装类型数组
            NSMutableDictionary *mOnePieceDic = [@{} mutableCopy];

            [mOnePieceDic setObject:[NSNumber numberWithInteger:mSideL] forKey:@(PieceSideTypeLeft)];
            [mOnePieceDic setObject:[NSNumber numberWithInteger:mSideT] forKey:@(PieceSideTypeTop)];
            [mOnePieceDic setObject:[NSNumber numberWithInteger:mSideB] forKey:@(PieceSideTypeBottom)];
            [mOnePieceDic setObject:[NSNumber numberWithInteger:mSideR] forKey:@(PieceSideTypeRight)];
            
            [self.pieceTypeArray addObject:mOnePieceDic];
            
            // 4. 组装裁剪和图像用的 frame 和 bouns
            CGFloat mStartPointX = self.tipsImgaeView.left;
            CGFloat mStartPointY = self.tipsImgaeView.top;
            [self.pieceCoordinateRectArray addObject:[NSArray arrayWithObjects:
                                                  [NSValue valueWithCGRect:CGRectMake(j*self.cubeWidthValue,  i*self.cubeHeightValue,mCubeWidth,mCubeHeight)],
                                                  [NSValue valueWithCGRect:CGRectMake(mStartPointX +j*self.cubeWidthValue-(mSideL == PieceTypeOutside?-self.deepnessV:0),mStartPointY + i*self.cubeHeightValue-(mSideT == PieceTypeOutside?-self.deepnessH:0), mCubeWidth, mCubeHeight)], nil]];
            
            [self.pieceRotationArray addObject:[NSNumber numberWithFloat:0]];
            mCounter++;
        }
    }
}

// 设置贝塞尔曲线
- (void)setUpPieceBezierPaths {
    // 1. 初始化临时数据
    float mYSideStartPos = 0; // Y边起点
    float mXSideStartPos = 0; // x边起点
    float mCustomDeepness = 0; // 深度。
    float mCurveHalfVLength = self.cubeWidthValue / 10;
    float mCurveHalfHLength = self.cubeHeightValue / 10;
    float mCurveStartXPos = self.cubeWidthValue / 2 - mCurveHalfVLength;
    float mCurveStartYPos = self.cubeHeightValue / 2 - mCurveHalfHLength;
    float mTotalHeight = 0; // 总高
    float mTotalWidth = 0; // 总宽
    
    // 2. 根据类型数据制作贝塞尔曲线
    for(int i = 0; i < [self.pieceTypeArray count]; i++) {
        // 2.1 根绝检测左边和下边是否凹决定起点
        mXSideStartPos = ([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeLeft)] integerValue] == PieceTypeOutside)?-self.deepnessV:0;
        mYSideStartPos = ([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] integerValue] == PieceTypeOutside)?-self.deepnessH:0;
        
        mTotalHeight = mYSideStartPos + mCurveStartYPos*2 + mCurveHalfHLength * 2;
        mTotalWidth = mXSideStartPos + mCurveStartXPos*2 + mCurveHalfVLength * 2;
        
        //2.2 初始化一条含凹凸的贝塞尔曲线
        UIBezierPath* mPieceBezier = [UIBezierPath bezierPath];
        [mPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        
        //2.2.2 绘制PieceSideTypeLeft
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)];
        
        if([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeLeft)] integerValue] != PieceTypeEmpty) {
            mCustomDeepness = self.deepnessV * [[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeLeft)] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25PieceTypeEmpty
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
  
        //2.2.2 绘制PieceSideTypeBottom
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        if([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeBottom)] integerValue] != PieceTypeEmpty) {
            mCustomDeepness = self.deepnessH * [[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeBottom)] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];

        
        //2.2.3 绘制PieceSideTypeRight
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        if([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeRight)] integerValue] != PieceTypeEmpty) {
            mCustomDeepness = self.deepnessV * [[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeRight)] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        
        
        //2.2.3 绘制PieceSideTypeTop
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        if([[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] integerValue] != PieceTypeEmpty) {
            mCustomDeepness = self.deepnessH * [[[self.pieceTypeArray objectAtIndex:i] objectForKey:@(PieceSideTypeTop)] intValue];

            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];

            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        
        [self.pieceBezierPathsArray addObject:mPieceBezier];
    }
}

- (void)setUpPuzzlePieceImages {
    float mXAddableVal = 0;
    float mYAddableVal = 0;
    
    _pieceImagesArray = [NSMutableArray array];
    _pieceImageViewsArray = [NSMutableArray array];
    
    for(int i = 0; i < [self.pieceBezierPathsArray count]; i++) {
        CGRect mCropFrame = [[[self.pieceCoordinateRectArray objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[self.pieceCoordinateRectArray objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
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
        [mPeace setImage:[self cropImage:self.originalCatImage withRect:mCropFrame]];
        [self setClippingPath:[self.pieceBezierPathsArray objectAtIndex:i]:mPeace];
        [self.view addSubview:mPeace];
        [mPeace setTransform:CGAffineTransformMakeRotation([[self.pieceRotationArray objectAtIndex:i] floatValue])];
        
        
        // 设置layer 已经边缘线条
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        [mBorderPathLayer setPath:[[self.pieceBezierPathsArray objectAtIndex:i] CGPath]];
        [mBorderPathLayer setFillColor:[UIColor clearColor].CGColor];
        [mBorderPathLayer setStrokeColor:[UIColor whiteColor].CGColor];
        [mBorderPathLayer setLineWidth:1];
        [mBorderPathLayer setFrame:CGRectZero];
        [[mPeace layer] addSublayer:mBorderPathLayer];

        // 添加手势
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMaximumNumberOfTouches:2];
        [panRecognizer setDelegate:self];
        [mPeace addGestureRecognizer:panRecognizer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [mPeace addGestureRecognizer:tap];

        [_pieceImagesArray addObject:mPeace.image];
        [_pieceImageViewsArray addObject:mPeace];
    }
    
    [self moveCubestoAnotherPlace];

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


// 修挣图片尺寸
- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)asize {
    UIImage *newimage;
    if (nil == img) {
        newimage = nil;
    } else{
        CGSize oldsize = img.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
            
        } else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background

        [img drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newimage;
}


#pragma mark ——— 手势相关
//static int bestScore = 0;
- (void)move:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.firstX = sender.view.center.x;
        self.firstY = sender.view.center.y;
    }
    UIImageView *mImgView = (UIImageView *)sender.view;
    translatedPoint = CGPointMake(self.firstX+translatedPoint.x, self.firstY+translatedPoint.y);
    [mImgView setCenter:translatedPoint];
    [self.view bringSubviewToFront:mImgView];
    
    // 验证相关
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGRect mImageFrame = [[[self.pieceCoordinateRectArray objectAtIndex:mImgView.tag-100] objectAtIndex:1] CGRectValue];
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
            if (_pointCorrectArr.count == (_level+2)*(_level+2)) {
                
                if (!_couldTouchImage) {
                    return;
                }
                
                [_timerView timerStop];

                [self performSelector:@selector(showPromotView) withObject:nil afterDelay:0.2];
            }
            
        }else{
            
            for (NSNumber *point in _pointCorrectArr) {
                
                if (point.CGPointValue.x == mimagePoint.x && point.CGPointValue.y == mimagePoint.y) {
                    
                    //已完成的mo块被移除，删除数组中c成功的块
                    [_pointCorrectArr removeObject:point];
                }
            }
            NSLog(@"位置不匹配，%@--- %@",NSStringFromCGPoint(mimagePoint),NSStringFromCGPoint(translatedPoint));
        }
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if (!_couldTouchImage) {

        return NO;
    }

    return YES;
}

- (void)showPromotView {
    
    MPSuccessView *successTip = (MPSuccessView *)[[NSBundle mainBundle] loadNibNamed:@"MPSuccessView" owner:nil options:nil][0];
    successTip.frame = self.view.frame;
    successTip.delegate = self;
    [self.view.window addSubview:successTip];
    
    if (self.level == 3) {
        
        [successTip changeNextButtonStatusForLastLevel];
    }
}

//拼图完成，重新开始游戏
- (void)promotetoPlay {
    
    _couldTouchImage = YES;
    
    [_timerView timerStop];
    
    [self removeAllPiece];
    [self setTimer];
    
    [self setInitData];
    [self initializeDataSet];
    [self setupPieceTypePieceCoordinateAndRotationValuesArrays];
    [self setUpPieceBezierPaths];
    [self setUpPuzzlePieceImages];
}

-(void)removeAllPiece {
    
    for (UIImageView *imgV in _pieceImageViewsArray) {
        
        [imgV removeFromSuperview];
    }
}

- (void)removeTipLabel:(id)object {
    
    UILabel *label = (UILabel *)object;
    [UIView animateWithDuration:1.0f animations:^{
        [label setAlpha:0];
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

- (void)tap:(UITapGestureRecognizer *)sender {
    
    UIImageView *imageView = (UIImageView *)sender.view;
    [self.view bringSubviewToFront:imageView];
}

- (void)moveCubestoAnotherPlace {
    
    NSMutableArray *imageViews = [NSMutableArray arrayWithArray:self.pieceCoordinateRectArray];
    NSMutableArray *pieceTypes = [NSMutableArray arrayWithArray:self.pieceTypeArray];
    
    
    CGFloat pieceWidth = self.tipsImgaeView.width/(_level+2);
    CGFloat pieceHeight = self.tipsImgaeView.height/(_level+2)+15;
    NSInteger pieceCount = (_level+2)*(_level + 2);
    
    NSMutableArray *pointCounts = [NSMutableArray array];

    NSInteger piecesALine = [UIScreen mainScreen].bounds.size.width/(pieceWidth+15);
    
    for (int i = 0; i < pieceCount; i++) {
       
        CGPoint center = CGPointMake((i%piecesALine+1/2)*(CGFloat)[UIScreen mainScreen].bounds.size.width/piecesALine, _tipsImgaeView.bottom+2+(i/piecesALine+1/2)*pieceHeight);

        [pointCounts addObject:@(center)];
    }

    if (!_pieceImageViewsArray.count) {
        return;
    }
    
    for (UIImageView *imgV in _pieceImageViewsArray) {
        
        //随机一张图放在放在imgv的位置上
        NSInteger randNum = rand()%imageViews.count;
        CGPoint itemPoint = [[pointCounts objectAtIndex:randNum] CGPointValue];
        
        CGPoint origin = itemPoint;
        origin.x +=  10;
        origin.y +=  10;
        //判断宽高大小，限制位置
        imgV.origin = origin;
        
        [pointCounts removeObjectAtIndex:randNum];
        [imageViews removeObjectAtIndex:randNum];
        [pieceTypes removeObjectAtIndex:randNum];
    }
    
}

#pragma mark - IB Action
- (IBAction)restartToPlay:(id)sender {
    
    [self promotetoPlay];
}

- (IBAction)backtToHome:(id)sender {
    
    if (self.refreshHomeViewStatus) {
        self.refreshHomeViewStatus(self.level);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showTip:(id)sender {
    [self showTip];
}

- (IBAction)hideTip:(id)sender {
    
    [self hideTip];
}


#pragma mark - delegate
- (void)tipViewtoBackHome {
    
    if (self.refreshHomeViewStatus) {
        self.refreshHomeViewStatus(self.level);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tipViewtoReplay {
 
    [self promotetoPlay];
}

- (void)tipViewtoPlayNextStage {
    
    if (self.level < 3) {
        self.level++;
    }

    [self promotetoPlay];
}

- (void)tipViewtoClose {
    
    _couldTouchImage = NO;
}

- (void)dealloc {
    
}

@end
