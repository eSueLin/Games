//
//  BYSystemVolum.h
//  MentalWork
//
//  Created by MentalWork on 5/22/19.
//  Copyright © 2019 MentalWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^SystemVolumBlock)(float volum);
@interface BYSystemVolum : NSObject

@property (nonatomic, copy) SystemVolumBlock systemVolumChanging;

+ (BYSystemVolum *)sharedVolum;

+ (UISlider *)getSystemVolumeSlider;

+ (float)getSystemVolum;

+ (void)setSystemVolum:(float)volum;

@end

NS_ASSUME_NONNULL_END
