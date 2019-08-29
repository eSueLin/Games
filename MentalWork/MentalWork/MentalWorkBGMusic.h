//
//  MentalWorkBGMusic.h
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MentalWorkBGMusic : NSObject

+ (MentalWorkBGMusic *)sharedInstance;

- (void)bgmforfailedflipingCards;

- (void)bgmforCleanningCards;

- (void)turnOnBGM;

- (void)turnOffBGM;

- (void)changeBGMVoice:(float)volum;

@end

NS_ASSUME_NONNULL_END
