//
//  LYDataMesta.h
//  LYPuzzle
//
//  Created by HC16 on 2019/5/7.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kGamePassStatus = @"LYGamePassStatus";

typedef void(^reportDataUpdate)(NSArray *updateArr);

@interface LYDataMesta : UIView

@property (nonatomic, copy) reportDataUpdate newStagePassedRepord;

+ (LYDataMesta*)sharedInstance;

- (void)dataUpdateWithStage:(NSInteger)stage;

- (void)removeData;

- (NSArray *)getLevelsWithPassed;

- (void)nomeanstoshowBlock:(reportDataUpdate)block;

@end

NS_ASSUME_NONNULL_END
