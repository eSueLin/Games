//
//  MPFailedView.h
//  Make_Package
//
//  Created by HC16 on 6/23/19.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTipViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPFailedView : UIView

@property (nonatomic, weak) id<MPTipViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
