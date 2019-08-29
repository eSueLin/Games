//
//  BYGameCenterInt.h
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYGameCenterInt : NSObject

+ (BYGameCenterInt *)gameCenter;
/** 用户验证 **/
- (void)authenticateLocalPlayer;

/** 上传当前游戏成绩 **/
- (void)reportResultScore:(NSInteger)score leaderBoard:(int)leaderBoardID;

/** 显示排行榜 **/
- (void)showRankListWithCurrentVC:(UIViewController *)currentVC;

/** 获取最高分 **/
- (void)asyntoLoadScores:(int)level;
@end

NS_ASSUME_NONNULL_END
