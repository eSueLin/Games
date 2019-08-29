//
//  BScoreStatic.m
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BScoreStatic.h"

@implementation BScoreStatic

static BScoreStatic *_scorestatic = nil;
+ (BScoreStatic *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scorestatic = [[BScoreStatic alloc] init];
    });
    
    return _scorestatic;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setDataInitForUserDefault];
    }
    return self;
}

- (void)setDataInitForUserDefault {
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kCleanCardsScore]) {
        
        NSArray *arr = @[@"0", @"0", @"0"];
        [self saveDataInUserDeafaults:arr];
    }
}

- (void)saveScore:(NSString *)score {
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kCleanCardsScore];
    NSMutableArray *mutaArr = [NSMutableArray arrayWithArray:arr];
    for (NSString *ss in arr) {
        if (score.integerValue >= ss.integerValue) {
            
            [mutaArr insertObject:score atIndex:[arr indexOfObject:ss]];
            break;
        }
    }
    if (mutaArr.count > 3) {
        [mutaArr removeLastObject];
    }
    
    [self saveDataInUserDeafaults:mutaArr];
}

- (NSArray *)getScore {
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kCleanCardsScore];
    
    return arr;
}

- (void)saveDataInUserDeafaults:(NSArray *)arr {
    
    [[NSUserDefaults standardUserDefaults] setValue:arr forKey:kCleanCardsScore];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
