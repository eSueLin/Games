//
//  LYDataMesta.m
//  LYPuzzle
//
//  Created by HC16 on 2019/5/7.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYDataMesta.h"

@implementation LYDataMesta

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static LYDataMesta *_dataM = nil;
+ (LYDataMesta *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dataM = [[LYDataMesta alloc] init];
    });
    return _dataM;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self dataReportIn];
    }
    return self;
}

- (void)dataReportIn {
    
    if (![self getUserDefaultsDataWithKey:kGamePassStatus]) {
        
        [self saveDatatoUserDefaultsWithArr:@[@(101)]];
    }
    
}

- (NSArray *)getUserDefaultsDataWithKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (void)saveDatatoUserDefaultsWithArr:(NSArray *)arr {
    
    [[NSUserDefaults standardUserDefaults] setValue:arr forKey:kGamePassStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getLevelsWithPassed {
    
    return [self getUserDefaultsDataWithKey:kGamePassStatus];
}

- (void)dataUpdateWithStage:(NSInteger)stage {
    
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObjectsFromArray:[self getUserDefaultsDataWithKey:kGamePassStatus]];
    
    //需要判断是否存在相同关卡
    if (stage == 106) {
        return;
    }
    for (NSNumber *num in dataArr) {
        
        if (num.integerValue == stage+1) {
            return;
        }
    }
    [dataArr addObject:@(stage+1)];
    [self saveDatatoUserDefaultsWithArr:dataArr];
    
    if (self.newStagePassedRepord) {
        
        self.newStagePassedRepord(dataArr);
    }
    
}

- (void)nomeanstoshowBlock:(reportDataUpdate)block {
    
    block([self getUserDefaultsDataWithKey:kGamePassStatus]);
}

- (void)removeData {
    
    
}
@end
