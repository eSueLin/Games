//
//  SCHomeHelpView.m
//  SweetCandy
//
//  Created by HC16 on 5/31/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCHomeHelpView.h"

@implementation SCHomeHelpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeView:(id)sender {
    
    if (self.responsetoCloseView) {
        self.responsetoCloseView();
    }
}

@end
