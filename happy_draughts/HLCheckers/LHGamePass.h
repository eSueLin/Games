//
//  LHGamePass.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/30.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLTool/HLToolbox.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshStatusblock)(void);
static NSString *const kGamePassStatue = @"HLGamePassedStatus";

@interface LHGamePass : NSObject

@property (nonatomic, copy) RefreshStatusblock refreshStatus;

+ (LHGamePass *)sharedInstance;

- (void)newGamePassWithLebelType:(GameLevelType)type;

- (void)restChessmanForBest:(NSInteger)restChessman withType:(GameLevelType)type;


@end

NS_ASSUME_NONNULL_END
