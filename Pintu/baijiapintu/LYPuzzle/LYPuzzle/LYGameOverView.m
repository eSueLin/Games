//
//  LYGameOverView.m
//  LYPuzzle
//
//  Created by HC16 on 2019/5/6.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYGameOverView.h"

@implementation LYGameOverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)exitGame:(id)sender {

    if ([self.delegate respondsToSelector:@selector(resulttoExitGame)]) {
        
        [self.delegate resulttoExitGame];
    }

}

- (IBAction)toPlayLastLevel:(id)sender {

    if ([self.delegate respondsToSelector:@selector(resultFailedtoPlayLastLevelGame:)]) {
        
        [self.delegate resultFailedtoPlayLastLevelGame:self];
    }
}

- (IBAction)replayGame:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(resulttoReplayGame:)]) {
        
        [self.delegate resulttoReplayGame:self];
    }
}


@end
