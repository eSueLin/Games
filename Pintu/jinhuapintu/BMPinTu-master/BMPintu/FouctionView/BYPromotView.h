//
//  BYPromotView.h
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BYPromotViewtoReplayDelegate <NSObject>

- (void)promotetoPlay;

- (void)closePromotView;

@end

@interface BYPromotView : UIView

@property (weak, nonatomic) IBOutlet UILabel *currentSco;
@property (weak, nonatomic) IBOutlet UILabel *bestSco;
@property (nonatomic, weak) id<BYPromotViewtoReplayDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
