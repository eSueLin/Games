//
//  HLResultView.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/29.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HLResultDelegate <NSObject>

- (void)resultViewtoBackHomeView;
//重新开始游戏
- (void)resultViewtoRestartGame;

//下一关
- (void)resultViewtoEnterNextGame;

@end

@interface HLResultView : UIView

@property (nonatomic, weak) id<HLResultDelegate> delegate;

- (void)refreshViewWithImageName:(NSString *)imageName countNum:(NSString *)numberImgName;

@end

NS_ASSUME_NONNULL_END
