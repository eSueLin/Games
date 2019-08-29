//
//  MentalWorkFailView.m
//  MentalWork
//
//  Created by HC16 on 5/18/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkFailView.h"

@implementation MentalWorkFailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)failtoBackHome:(id)sender {

    if ([self.delegate respondsToSelector:@selector(mentalWorktoBackHome)]) {
        
        [self removeFromSuperview];
        [self.delegate mentalWorktoBackHome];
    }
}

- (IBAction)failtoRestartGAme:(id)sender {

    if ([self.delegate respondsToSelector:@selector(mentalWorktoRestartGame)]) {
        
        [self removeFromSuperview];
        [self.delegate mentalWorktoRestartGame];
    }
}

@end
