//
//  LYPuzzlePiecesImage.h
//  LYPuzzle
//
//  Created by HC16 on 2019/4/17.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, PieceType) {
    
    PieceTypeInside = -1,   //凸边（对应长度加长）
    PieceTypeEmpty,         //平整边缘
    PieceTypeOutside        //凹b（对应长度减小）
} ;

//
typedef NS_ENUM(NSInteger, PieceSideType) {
    
    PieceSideTypeLeft,
    PieceSideTypeRight,
    PieceSideTypeTop,
    PieceSideTypeBottom,
    PieceSideTypeCount      //占位
};

@protocol LYPuzzlePiecesImageDelegate <NSObject>

- (void)puzzleImagesGestureReconizeDelegateRespondWithGesture:(UIGestureRecognizer *)gestureRecognizer receiveTouch:(UITouch *)touch;

- (void)puzzleImagesMovetoTargetFrameFinishedWithObject:(id)object;

@end
@interface LYPuzzlePiecesImage : NSObject

@property (nonatomic, strong) NSMutableArray *pieceImageViewsArray;

@property (nonatomic, assign) NSInteger pieceLevel;

@property (nonatomic, weak)  id <LYPuzzlePiecesImageDelegate> delegate;

- (instancetype)initPuzzlePiecesWithImage:(NSString *)imageName tipsView:(UIImageView *)imgView;

- (void)startSliceWithSuperView:(UIView *)surpView;

- (void)setUpPieceWithPieceTypePCoodinateAndPRotationArr;

- (void)setupBezierPath;

- (void)addPuzzleImageswithSurperView:(UIView *)surpView;

- (void)resetData;

@end



NS_ASSUME_NONNULL_END
