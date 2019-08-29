//
//  SCGamePassView.h
//  SweetCandy
//
//  Created by HC16 on 5/31/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^passViewBlock)(BOOL isbackHome);
@interface SCGamePassView : UIView

@property (nonatomic, copy) passViewBlock buttonResponse;

- (void)resetLevelShowed:(NSInteger)level;

- (void)refreshTimerWithCompleteTime:(NSString *)currentTime bestTime:(NSString *)bestTime;

@end

NS_ASSUME_NONNULL_END
