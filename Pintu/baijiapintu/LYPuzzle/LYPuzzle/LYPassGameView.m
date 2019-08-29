//
//  LYPassGameView.m
//  LYPuzzle
//
//  Created by HC16 on 2019/5/6.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYPassGameView.h"

@implementation LYPassGameView
{
    
    
    __weak IBOutlet UIButton *onemoreBtn;
    __weak IBOutlet UIButton *nextBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    [super awakeFromNib];
    onemoreBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    nextBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)exitGme:(id)sender {

    if ([self.delegate respondsToSelector:@selector(resulttoExitGame)]) {
        
        [self.delegate resulttoExitGame];
    }
}

- (IBAction)replayGame:(id)sender {

    if ([self.delegate respondsToSelector:@selector(resulttoReplayGame:)]) {
        [self.delegate resulttoReplayGame:self];
    }
}

- (IBAction)toPlayNextLevel:(id)sender {

    if ([self.delegate respondsToSelector:@selector(resulttoPlayNextLevelGame:)]) {
        
        [self.delegate resulttoPlayNextLevelGame:self];
    }
}


@end
