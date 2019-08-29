//
//  HLCGSuccessView.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/30.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLResultView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLCGSuccessView : UIView

@property (nonatomic, weak) id<HLResultDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
