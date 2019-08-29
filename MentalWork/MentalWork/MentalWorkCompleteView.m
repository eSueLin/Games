//
//  MentalWorkCompleteView.m
//  MentalWork
//
//  Created by HC16 on 5/18/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkCompleteView.h"

@implementation MentalWorkCompleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)backtoHome:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(mentalWorktoBackHome)]) {
        
        [self removeFromSuperview];
        [self.delegate mentalWorktoBackHome];
    }
}
- (IBAction)completedtoRestartGame:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(mentalWorktoNextGame)]) {
        
        [self removeFromSuperview];
        [self.delegate mentalWorktoNextGame];
    }
}

@end
