//
//  BRecordView.m
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BRecordView.h"
#import "../Founction/BScoreStatic.h"

@implementation BRecordView
{
    
    __weak IBOutlet UILabel *goldLabel;
    __weak IBOutlet UILabel *silverLabel;
    __weak IBOutlet UILabel *grounceLabel;
    
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
    
    NSArray *scoreArr = [[BScoreStatic shareInstance] getScore];
    goldLabel.text = scoreArr[0];
    silverLabel.text = scoreArr[1];
    grounceLabel.text = scoreArr[2];
}

- (IBAction)closeClick:(id)sender {

    [self removeFromSuperview];
    if (self.recordAction) {
        self.recordAction(YES);
    }
}

- (IBAction)backtoHome:(id)sender {

    [self removeFromSuperview];
    if (self.recordAction) {
        self.recordAction(NO);
    }
}


@end
