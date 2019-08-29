//
//  SCGameAreaView.h
//  SweetCandy
//
//  Created by HC16 on 6/2/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../SCTool/SCHeaders.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SCGameViewLevel) {
    
    SCGameViewLevelOne = 1,
    SCGameViewLevelTwo,
    SCGameViewLevelThr,
    SCGameViewLevelFour,
    SCGameViewLevelFive,
    SCGameViewLevelSix,
};

@interface SCGameAreaView : UIView<UIImageViewGestureDelegate>

+ (SCGameAreaView *)shareInstance;

@property (nonatomic, weak) id<HLCheckerRulesDelegate> delegate;

- (void)getStageWithLevel:(SCGameViewLevel)level gameAreaBottomView:(UIImageView *)gameArea left:(nonnull void (^)(int leftCount))leftblock;

- (void)removeCurrentView;

@end

NS_ASSUME_NONNULL_END
