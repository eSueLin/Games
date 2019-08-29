//
//  SCGameOverView.m
//  SweetCandy
//
//  Created by HC16 on 6/4/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCGameOverView.h"

@implementation SCGameOverView
{
    
    __weak IBOutlet UIImageView *levelImageView;
    
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
}

- (IBAction)backtoHome:(id)sender {

    if (self.gameoverBtnRespone) {
        self.gameoverBtnRespone(YES);
    }
}

- (IBAction)restartGame:(id)sender {

    if (self.gameoverBtnRespone) {
        self.gameoverBtnRespone(NO);
    }
}

- (void)resetLevelShowed:(NSInteger)level {
    
    [levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"L%ld", level]]];
}

@end
