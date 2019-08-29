//
//  LYGameOverView.h
//  LYPuzzle
//
//  Created by HC16 on 2019/5/6.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYGameResultDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface LYGameOverView : UIView

@property (nonatomic, weak) id<LYGameResultDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
