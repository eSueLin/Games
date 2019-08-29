//
//  DCGameOverView.m
//  DodgeCombat
//
//  Created by HC16 on 6/11/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "DCGameOverView.h"

@implementation DCGameOverView
{
    __weak IBOutlet UIImageView *firstNumImgV;
    __weak IBOutlet UIImageView *secNumImgV;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showScore:(int)score {
    
    if (0 == score/10) {
        [firstNumImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"blue_%i", score]]];
        [secNumImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@""]]];
        return;
    }
    
    [firstNumImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"blue_%i", score/10]]];
    [secNumImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"blue_%i", score%10]]];
    
}

//restart
- (IBAction)showrankView:(id)sender {
    
    [self removeFromSuperview];
    if (self.eventRespone) {
        
        self.eventRespone(NO);
    }
    
}

//back to home
- (IBAction)leftButtonClick:(id)sender {
    
    
    if (self.eventRespone) {
        self.eventRespone(YES);
    }
}


@end
