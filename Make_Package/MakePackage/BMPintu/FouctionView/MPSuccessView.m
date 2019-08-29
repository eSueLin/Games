//
//  MPSuccessView.m
//  Make_Package
//
//  Created by HC16 on 6/23/19.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "MPSuccessView.h"

@implementation MPSuccessView
{
    
    __weak IBOutlet UIButton *NextButton;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)changeNextButtonStatusForLastLevel {
    
//    NSParameterAssert(self);
    NextButton.enabled = NO;
}

- (IBAction)closeSuccessView:(id)sender {
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(tipViewtoClose)]) {
        [self.delegate tipViewtoClose];
    }
}

- (IBAction)backtoHomeView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tipViewtoBackHome)]) {
        
        [self removeFromSuperview];
        [self.delegate tipViewtoBackHome];
    }
}

- (IBAction)playNextStage:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tipViewtoPlayNextStage)]) {
        
        [self removeFromSuperview];
        [self.delegate tipViewtoPlayNextStage];
    }
}

@end
