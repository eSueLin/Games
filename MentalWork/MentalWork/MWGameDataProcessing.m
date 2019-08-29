//
//  MWGameDataProcessing.m
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MWGameDataProcessing.h"

@implementation MWGameDataProcessing

+ (NSString *)getGameTimeWithLevel:(int)level {
    
    NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"LevelTimeLimit" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistStr];
    
    NSString *timeStr = [plistDict valueForKey:[NSString stringWithFormat:@"%i", level]];
    int time = timeStr.intValue;
    
    NSString *timeStrFormat = @"";
    if (time<60) {
        timeStrFormat = [NSString stringWithFormat:@"00:%i", time];
    } else {
        int min = time/60;
        int sec = time%60;
        if (sec < 10) {
            
            timeStrFormat = [NSString stringWithFormat:@"0%i:0%i", min, sec];
        } else {
            timeStrFormat = [NSString stringWithFormat:@"0%i:%i", min, sec];
        }
    }
    
    return timeStrFormat;
}

+ (NSMutableArray *)createArrayForImagesNameWithVer:(int)ki Hor:(int)kj {
    
    NSMutableArray *cardsNameArr = [NSMutableArray array];
    int cardsNum = ki*kj/2;
    NSMutableArray *numArr  = [NSMutableArray array];
    for (int i = 0 ; i < 12; i++) {
        
        [numArr addObject:[NSString stringWithFormat:@"%i", i+1]];
    }
    
    do {
        
        int cardpoint = arc4random()%numArr.count;
        
        
        [cardsNameArr addObject:numArr[cardpoint]];
        [numArr removeObjectAtIndex:cardpoint];
        cardsNum--;
        
    } while (cardsNum > 0);
    
        [cardsNameArr addObjectsFromArray:cardsNameArr];
    
    //重新随机排序
    NSMutableArray *arr = [NSMutableArray arrayWithArray:cardsNameArr];
    [cardsNameArr removeAllObjects];
    
    do {
        
        int random = arc4random()%arr.count;
        [cardsNameArr addObject:arr[random]];
        [arr removeObjectAtIndex:random];
        
    } while (arr.count > 0);
    
    return cardsNameArr;
}

+ (NSArray *)getGameAreaTypeFromPlistWithLevel:(int)level {
    
    NSArray *arr;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LevelType" ofType:@"plist"];
    
    NSDictionary *plistArr = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *str = [plistArr valueForKey:[NSString stringWithFormat:@"%i", level]];
    
    arr = [str componentsSeparatedByString:@"x"];
    
    return arr;
}
@end
