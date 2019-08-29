//
//  BGameOvew.m
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "BGameOver.h"
#import "BRecordView.h"

@implementation BGameOver

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeClick:(id)sender {
    
    [self removeFromSuperview];
    //返回首页
    if (self.overblock) {
        self.overblock(NO);
    }
}

- (IBAction)recordClick:(id)sender {
    
    //show record view
    UIView *surperView = [self superview];
    NSArray *nibsArr = [[NSBundle mainBundle] loadNibNamed:@"BRecordView" owner:nil options:nil];
    BRecordView *recordV = [nibsArr firstObject];
    recordV.frame = self.frame;
    
    __block typeof(self) overV = self;
    recordV.recordAction = ^(BOOL isbacktoHome) {
      
        if (isbacktoHome) {
            
            [overV closeClick:nil];
        } else {
            
            [overV showSelfFromRecordView];
        }
    };
    
    [surperView addSubview:recordV];
    self.alpha = 0;
}

- (void)showSelfFromRecordView {
    
    self.alpha = 1;
}

- (IBAction)playAgain:(id)sender {
    
    //call to replay
    [self removeFromSuperview];
    if (self.overblock) {
        self.overblock(YES);
    }
}


@end
