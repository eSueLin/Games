//
//  SCTimerUsedStore.m
//  SweetCandy
//
//  Created by HC16 on 6/5/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCTimerUsedStore.h"

#define TIMERUSEDSTORE @"SCTimerUsedStore"

@implementation SCTimerUsedStore

+ (SCTimerUsedStore *)defaultTimerUserd {
    
    static SCTimerUsedStore *timerStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        timerStore = [[SCTimerUsedStore alloc] init];
    });
    
    return timerStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        [self initStore];
    }
    return self;
}

- (void)initStore {
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:TIMERUSEDSTORE]) {

        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            
            [arr addObject:@[@(i)]];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:arr forKey:TIMERUSEDSTORE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)saveStage:(int)level usedTime:(int)timeSec timeString:(NSString *)timeStr {
    
    NSArray *historyArr = [self getBestScoreWithStage:level];
    if ([historyArr[1] intValue] < timeSec && [historyArr[1] intValue] != 0) {
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@(level)];
    [arr addObject:@(timeSec)];
    [arr addObject:timeStr];
    
    NSMutableArray *storeArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:TIMERUSEDSTORE]];
    
    [storeArr replaceObjectAtIndex:level-1 withObject:arr];
    [[NSUserDefaults standardUserDefaults] setValue:storeArr forKey:TIMERUSEDSTORE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getBestScoreWithStage:(int)level {
    
    NSArray *storeArr = [[NSUserDefaults standardUserDefaults] valueForKey:TIMERUSEDSTORE];
    
    NSMutableArray *levelArr = [NSMutableArray arrayWithArray:[storeArr objectAtIndex:level-1]];
    if (levelArr.count == 1) {
        
        [levelArr addObject:@(0)];
        [levelArr addObject:@"00:00"];
    }
    
    
    return levelArr;
}



@end
