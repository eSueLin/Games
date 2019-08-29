//
//  HLCheckersRules.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HLGameViewModel) {
    
    HLGameViewModelSquare,
    HLGameViewModelTriangle
};

NS_ASSUME_NONNULL_BEGIN
@protocol HLCheckerRulesDelegate <NSObject>

- (void)checkerRulesRemoveChessmanWithRest:(NSInteger)count;

- (void)checkerRulesGameOver;

- (void)checkerRulesGameSuceessful;

@end

@interface HLCheckersRules : NSObject

@property (nonatomic, strong) NSMutableArray *chessmenMutaArray;

@property (nonatomic, strong) NSMutableArray *checkerboardMutaArray;

@property (nonatomic, assign) CGSize checkerboardSize;

@property (nonatomic, weak) id<HLCheckerRulesDelegate> delegate;

@property (nonatomic, assign) HLGameViewModel viewModel;

- (BOOL)checkChessmenOnLineWithFirstPoint:(CGPoint)firstPoint endPoint:(CGPoint)endPoint;

- (void)chessmanMovedWithPanGesture:(UIPanGestureRecognizer *)pan withSurperView:(UIView *)surpView;

- (void)backtoLastStep;

@end

NS_ASSUME_NONNULL_END
