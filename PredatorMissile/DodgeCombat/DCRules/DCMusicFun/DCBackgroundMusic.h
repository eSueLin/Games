//
//  DCBackgroundMusic.h
//  PredatorMissile
//
//  Created by HC16 on 6/13/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCBackgroundMusic : NSObject

+ (DCBackgroundMusic *)defaultMusic;

/** 打开背景音乐 **/
- (void)turnonMusic;

/** 关闭背景音乐 **/
- (void)turnoffMusic;

- (void)changeBGMVoice:(float)volum;


@end

NS_ASSUME_NONNULL_END
