//
//  SCGamePassView.m
//  SweetCandy
//
//  Created by HC16 on 5/31/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCGamePassView.h"

@implementation SCGamePassView
{
    
    __weak IBOutlet UIView *newTimeView;
    __weak IBOutlet UIView *bestTimeView;
    __weak IBOutlet UIImageView *labelImageView;
    
    UILabel *newTimeLabel;
    UILabel *bestTimeLabel;
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
    
    [self setTimeView];

}

- (void)setTimeView {
    
    newTimeLabel = [self setLabel:newTimeLabel frame:newTimeView.frame];
    bestTimeLabel = [self setLabel:bestTimeLabel frame:bestTimeView.frame];
    
    [self addSubview:newTimeLabel];
    [self addSubview:bestTimeLabel];
}

- (void)resetLevelShowed:(NSInteger)level {
    
    [labelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"L%ld", level]]];
}

- (UILabel *)setLabel:(UILabel *)label frame:(CGRect)frame{
    
    label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"00:00";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.contentMode = UIViewContentModeCenter;
    return label;
}

- (void)refreshTimerWithCompleteTime:(NSString *)currentTime bestTime:(NSString *)bestTime{
    
    [newTimeLabel setText:currentTime];
    [bestTimeLabel setText:bestTime];
}

- (IBAction)backHome:(id)sender {

    if (self.buttonResponse) {
        self.buttonResponse(YES);
    }
}

- (IBAction)nextStage:(id)sender {
    
    if (self.buttonResponse) {
        self.buttonResponse(NO);
    }
}


@end
