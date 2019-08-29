//
//  LHGamePass.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/30.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LHGamePass.h"

@implementation LHGamePass

static LHGamePass *passedst = nil;
+ (LHGamePass *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        passedst = [[LHGamePass alloc] init];
     });
    return passedst;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initData];
    }
    return self;
}

- (void)initData {
    
    NSMutableArray *mutaArr = [NSMutableArray array];
    [mutaArr addObject:@(GameLevelTypeFirst)];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue]) {
        [[NSUserDefaults standardUserDefaults] setValue:mutaArr forKey:kGamePassStatue];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
  
}

- (void)newGamePassWithLebelType:(GameLevelType)type {
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue]];
   
    if ([arr containsObject:@(type)]) {
        NSLog(@"contains");
        return;
    }
    
    [arr addObject:@(type)];
    
    [[NSUserDefaults standardUserDefaults] setValue:arr forKey:kGamePassStatue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.refreshStatus) {
        self.refreshStatus();
    }
}

//- (void)restChessmanForBest:(NSInteger)restChessman withType:(GameLevelType)type {
//
//    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@""];
//}


@end
