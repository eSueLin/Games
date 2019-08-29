//
//  BYSystemVolum.m
//  MentalWork
//
//  Created by MentalWork on 5/22/19.
//  Copyright © 2019 MentalWork. All rights reserved.
//

#import "BYSystemVolum.h"


@implementation BYSystemVolum

+ (BYSystemVolum *)sharedVolum {
    
    static BYSystemVolum *_volum = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _volum = [[BYSystemVolum alloc] init];
    });
    
    return _volum;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChange:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
    return self;
}

-(void)volumeChange:(NSNotification*)notifi{
    
    NSString * style = [notifi.userInfo objectForKey:@"AVSystemController_AudioCategoryNotificationParameter"];
    
    CGFloat value = [[notifi.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] doubleValue];
    
    if ([style isEqualToString:@"Ringtone"]) {
        
        NSLog(@"铃声改变");
        
    }else if ([style isEqualToString:@"Audio/Video"]){
        
//        NSLog(@"音量改变当前值:%f",value);
        //notifi to changing
        if (self.systemVolumChanging) {
            self.systemVolumChanging(value);
        }
    }
}

+ (UISlider *)getSystemVolumeSlider {
    
    static UISlider *volumViewSlider = nil;
    if (volumViewSlider == nil) {
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        for (UIView * newView  in volumeView.subviews) {
            
            if ([[newView.class description] isEqualToString:@"MPVolumeSlider"] ) {
                volumViewSlider = (UISlider *)newView;
                volumViewSlider.center = CGPointMake(-1000, -1000);
                break;
            }
        }
    }
    return volumViewSlider;
}

+ (float)getSystemVolum {

    return [BYSystemVolum getSystemVolumeSlider].value;
}

+ (void)setSystemVolum:(float)volum {
    
    [BYSystemVolum getSystemVolumeSlider].value = volum;
}

@end
