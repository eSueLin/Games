//
//  MentalWorkBGMusic.m
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkBGMusic.h"
#import "BYSystemVolum.h"

@interface MentalWorkBGMusic()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;
@property (nonatomic, strong) AVAudioPlayer *failPlayer;
@property (nonatomic, strong) AVAudioPlayer *successPlayer;

@end

@implementation MentalWorkBGMusic
{
    NSOperationQueue *_avplayerOP;
}

static MentalWorkBGMusic *_bgm = nil;
+ (MentalWorkBGMusic *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _bgm = [[MentalWorkBGMusic alloc] init];
    });
    
    return _bgm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _avplayerOP = [[NSOperationQueue alloc] init];
        [self initPlayers];
    }
    return self;
}

- (void)initPlayers {

    [self playBGMWithMusicURL:[self getBGMPathWithFileName:@"bgm"]];

    NSURL *musicURL = [self getBGMPathWithFileName:@"fail"];
    _failPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    [self playWithAudioPlayer:_failPlayer];
    
    _successPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getBGMPathWithFileName:@"success"] error:nil];
    [self playWithAudioPlayer:_successPlayer];
    
    [self addtoOperationQiueueWithplayer:_bgmPlayer];

    __block typeof(self) bgmusic = self;
    [BYSystemVolum sharedVolum].systemVolumChanging = ^(float volum) {
      
        [bgmusic changeBGMVoice:volum];
    };
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

- (void)addtoOperationQiueueWithplayer:(AVAudioPlayer *)player {
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(willPlay:) object:player];
    [_avplayerOP addOperation:op];
 
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

- (void)turnOnBGM {
    
    
}

- (void)bgmforfailedflipingCards {
    

    [self addtoOperationQiueueWithplayer:_failPlayer];

    _failPlayer.volume = [BYSystemVolum getSystemVolum]*1.2;
}


- (void)bgmforCleanningCards {

    [self addtoOperationQiueueWithplayer:_successPlayer];

    
    _successPlayer.volume = 0.8;
}

- (void)bgmforCompletingGame {
    
//    [self playBGMWithMusicURL:[self getBGMPathWithFileName:@"fail"]];
}

- (void)bgmforFailedGame {
    
//    [self playBGMWithMusicURL:[self getBGMPathWithFileName:@"fail"]];
}

- (void)turnOffBGM {
    
    [_bgmPlayer stop];
}

- (void)changeBGMVoice:(float)volum {
    
    _bgmPlayer.volume = volum;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (player == _bgmPlayer) {
        return;
    }
    [_bgmPlayer play];
}

@end
