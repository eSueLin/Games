//
//  HLCheckersView.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLCheckersRules.h"
#import "../HLTool/HLToolbox.h"

#define ScreenWith [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface HLCheckersView : UIView<UIImageViewCheckersDelegate, HLCheckerRulesDelegate>

@property (nonatomic, strong) HLCheckersRules *rules;
@property (nonatomic, assign) CGSize checkerFallenSize; //棋子落点

- (void)setImageViewforCheckerboard;

- (void)restartGame;

@end

NS_ASSUME_NONNULL_END
