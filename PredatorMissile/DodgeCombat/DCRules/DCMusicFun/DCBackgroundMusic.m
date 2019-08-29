//
//  DCBackgroundMusic.m
//  PredatorMissile
//
//  Created by HC16 on 6/13/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCBackgroundMusic.h"
#import "BYSystemVolum.h"

@interface DCBackgroundMusic()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;

@end

@implementation DCBackgroundMusic

+ (DCBackgroundMusic *)defaultMusic {
    
    static DCBackgroundMusic *_bgmusic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bgmusic = [[DCBackgroundMusic alloc] init];
    });
    
    return _bgmusic;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initPlayer];
    }
    return self;
}

- (void)initPlayer {
    [self playBGMWithMusicURL:[self getBGMPathWithFileName:@"m_game1"]];
}

static bool isfirstIn = YES;
- (void)playWithAudioPlayer:(AVAudioPlayer *)player {
    [player prepareToPlay];
    
    float volum ;
    if (isfirstIn) {
        volum = [AVAudioSession sharedInstance].outputVolume;
        isfirstIn = NO;
    } else {
        volum = [BYSystemVolum getSystemVolum];
    }
    player.delegate = self;
    player.volume = volum;
    if (player == _bgmPlayer ) {
        
        player.numberOfLoops = -1;
        
    } else {
        player.numberOfLoops = 0;
    }
}

- (void)willPlay:(AVAudioPlayer *)player {
    
    [player play];
}

- (NSURL *)getBGMPathWithFileName:(NSString *)name {
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"mp3"];
    NSURL *bgmURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    return bgmURL;
}

- (void)playBGMWithMusicURL:(NSURL *)url {
    
    _bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    [self playWithAudioPlayer:_bgmPlayer];
}


- (void)turnonMusic {
    
    [_bgmPlayer play];
}

- (void)turnoffMusic {
    
    [_bgmPlayer stop];
}

- (void)changeBGMVoice:(float)volum {
    
    _bgmPlayer.volume = volum;
}

@end
