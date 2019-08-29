//
//  MWData.m
//  MentalWork
//
//  Created by HC16 on 5/19/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MWData.h"

@implementation MWData

static MWData *_mwdata = nil;
+ (MWData *)defaultData {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mwdata = [[MWData alloc] init];
    });
    
    return _mwdata;
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
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"MWUnLockLevelData"]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"MWUnLockLevelData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (int)getUnLockLevel {
    
    int unlocks = [[[NSUserDefaults standardUserDefaults] valueForKey:@"MWUnLockLevelData"] intValue];;
    
    return unlocks;
}

- (void)saveUnLockLevel:(int)unlocklevel {
    
    int saveUnlock = [self getUnLockLevel];
    if (saveUnlock > unlocklevel) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", unlocklevel] forKey:@"MWUnLockLevelData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
