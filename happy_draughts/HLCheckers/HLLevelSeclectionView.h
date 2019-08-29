//
//  HLLevelSeclectionView.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTool/HLToolbox.h"
#import "LHGamePass.h"


@protocol HLLevelSelectionDelegate <NSObject>

- (void)levelSelectedtoEnterGameWithGameLevelType:(GameLevelType)type;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLLevelSeclectionView : UIView

@property (nonatomic, weak) id<HLLevelSelectionDelegate> delegate;

- (void)selectionViewWillAppearFromOtherPage;

@end

NS_ASSUME_NONNULL_END
