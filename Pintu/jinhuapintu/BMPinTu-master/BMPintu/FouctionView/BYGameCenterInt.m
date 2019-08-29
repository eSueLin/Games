//
//  BYGameCenterInt.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BYGameCenterInt.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"

@interface BYGameCenterInt ()<GKGameCenterControllerDelegate,GameCenterManagerDelegate>

@end

@implementation BYGameCenterInt

static BYGameCenterInt *gameCenter = nil;
+ (BYGameCenterInt *)gameCenter {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gameCenter = [[BYGameCenterInt alloc] init];
    });
    
    return gameCenter;
}

//用户验证
- (void)authenticateLocalPlayer {
    

    [GameCenterManager sharedManager].delegate = self;
    BOOL availability = [[GameCenterManager sharedManager] checkGameCenterAvailability:YES];

    
}
//提交用户得分
- (void)reportResultScore:(NSInteger)score leaderBoard:(int)leaderBoardID{
    
//    if (GKLocalPlayer.localPlayer.authenticated) {
//        
//        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@""];
//        scoreReporter.value = score;
//        
//        NSArray<GKScore *> *scoreArray = [NSArray arrayWithObject:scoreReporter];
//        
//        [GKScore reportScores:scoreArray withCompletionHandler:^(NSError * _Nullable error) {
//            
//            if (error != nil) {
//                NSLog(@"report error:%@", error);
//            }
//        }];
//    }
    NSString *leaderBoard = [self getLeaderBoardWithLevel:leaderBoardID];

    
    [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:leaderBoard sortOrder:GameCenterSortOrderLowToHigh];
}


- (NSString *)getLeaderBoardWithLevel:(int)level {
    
    NSString * leaderBoard= @"";
    switch (level) {
        case 3:
            leaderBoard = @"thdLeaderBoardID";
            break;
        case 4:
            leaderBoard = @"frthLeaderBoardID";
            break;
        case 5:
            leaderBoard = @"ffthLeaderBoardID";
            break;
            
        default:
            break;
    }
    
    return leaderBoard;
}


//显示排行榜
- (void)showRankListWithCurrentVC:(UIViewController *)currentVC {
    
//    GKStateMachine *stateMachine = [GKState state].stateMachine;
    
//    GKGameCenterViewController *gameVC = [[GKGameCenterViewController alloc] init];
//    gameVC.gameCenterDelegate = self;
//
//    [currentVC presentViewController:gameVC animated:YES completion:nil];
    [[GameCenterManager sharedManager] presentAchievementsOnViewController:currentVC];
}

/** 退出排行版回调处理 **/
- (void)gameCenterViewControllerDidFinish:(nonnull GKGameCenterViewController *)gameCenterViewController {
    
}

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    
     UIViewController *rootVC = [[UIApplication sharedApplication].windows[0] rootViewController];
    [rootVC presentViewController:gameCenterLoginController animated:YES completion:^{
       
    }];
}

//多线程获取最高分
//获取gamecenter上的排行有延时问题～暂时在开始游戏的时候开启线程获取即时分数
- (void)asyntoLoadScores:(int)level {
    
    dispatch_queue_t  asynOnBackgroundThread = dispatch_get_global_queue(0, 0ul);
    dispatch_async(asynOnBackgroundThread, ^{
       
        NSString *leaderboard = [self getLeaderBoardWithLevel:level];
        
        GKLeaderboard *leaderboadRequest = [GKLeaderboard new];
        //设置好友的范围
        leaderboadRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        //指定那个区域的排行榜
        NSString *type = @"today";
        if ([type isEqualToString:type]) {
            leaderboadRequest.timeScope = GKLeaderboardTimeScopeToday;
            
        }else if([type isEqualToString:@"week"]){
            leaderboadRequest.timeScope = GKLeaderboardTimeScopeWeek;
            
        }else if([type isEqualToString:@"all"]){
            leaderboadRequest.timeScope = GKLeaderboardTimeScopeAllTime;
            
        }
        //哪一个排行榜
        leaderboadRequest.identifier = leaderboard;
        //从那个排名到那个排名
        NSInteger location = 1;
        NSInteger length = 10;
        leaderboadRequest.range = NSMakeRange(location, length);
        //请求数据
        [leaderboadRequest loadScoresWithCompletionHandler:^(NSArray<GKScore *> * _Nullable scores, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"请求分数失败");
                NSLog(@"error = %@",error);
            }else{
                NSLog(@"请求分数成功");
                //定义一个可变字符串存放用户信息
                NSMutableString *userInfo = [NSMutableString string];
                NSString *rankBoardID = nil;
                if (scores.count == 0) {
                    
//                    [NSUserDefaults standardUserDefaults] setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
                }
                for (GKScore *score in scores) {
                    NSLog(@"");
                    //得到排行榜的 id
                    NSString *gamecenterID = score.leaderboardIdentifier;
                    NSString *playerName = score.player.displayName;
                    NSInteger scroeNumb = score.value;
                    NSInteger rank = score.rank;
                    NSLog(@"排行榜 = %@，玩家名字 = %@，玩家分数 = %zd，玩家排名 = %zd",gamecenterID,playerName,scroeNumb,rank);
                    if (rank == 1) {

                        [[NSUserDefaults standardUserDefaults] setValue:@(scroeNumb) forKey:[NSString stringWithFormat:@"%i", level]];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        return ;
                    }
                    
                    [userInfo appendString:[NSString stringWithFormat:@"玩家名字 = %@，玩家分数 = %zd，玩家排名 = %zd",playerName,scroeNumb,rank]];
                    [userInfo appendString:@"\n"];
                    rankBoardID = gamecenterID;
                }
                //弹框展示
            }
        }];
        
    });
    
}

@end
