//
//  HLBaseViewController.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/26.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckersViews/HLCheckersViewsHeader.h"
#import "LHGamePass.h"

NS_ASSUME_NONNULL_BEGIN
@interface HLBaseViewController : UIViewController

@property (nonatomic) GameLevelType gameLevel;

@property (nonatomic, copy) RefreshStatusblock statusChange;

@end

NS_ASSUME_NONNULL_END
