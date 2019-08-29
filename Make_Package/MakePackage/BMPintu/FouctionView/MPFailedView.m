//
//  MPFailedView.m
//  Make_Package
//
//  Created by HC16 on 6/23/19.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "MPFailedView.h"

@implementation MPFailedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeTipView:(id)sender {
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tipViewtoClose)]) {
        [self.delegate tipViewtoClose];
    }
}

- (IBAction)backtoHomeView:(id)sender {
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tipViewtoBackHome)]) {
        [self.delegate tipViewtoBackHome];
    }
}

- (IBAction)playtoRestart:(id)sender {

    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tipViewtoReplay)]) {
        [self.delegate tipViewtoReplay];
    }
}



@end
