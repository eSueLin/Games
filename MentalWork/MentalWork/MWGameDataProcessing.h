//
//  MWGameDataProcessing.h
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWGameDataProcessing : NSObject

+ (NSString *)getGameTimeWithLevel:(int)level;

+ (NSMutableArray *)createArrayForImagesNameWithVer:(int)ki Hor:(int)kj;

//获取游戏模式 2*4/2*6...
+ (NSArray *)getGameAreaTypeFromPlistWithLevel:(int)level;
@end

NS_ASSUME_NONNULL_END
