//
//  HLCGSuccessView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/30.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLCGSuccessView.h"

@implementation HLCGSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
}

- (IBAction)closeView:(id)sender {
    
    [self removeFromSuperview];
}


- (IBAction)backtoHomeView:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(resultViewtoBackHomeView)]) {
        
        [self.delegate resultViewtoBackHomeView];
    }
}

- (IBAction)enterNextLevel:(id)sender {


    if ([self.delegate respondsToSelector:@selector(resultViewtoEnterNextGame)]) {
        
        [self removeFromSuperview];
        [self.delegate resultViewtoEnterNextGame];
    }
}

@end
