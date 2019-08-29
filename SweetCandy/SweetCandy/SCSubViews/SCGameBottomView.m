//
//  SCGameBottomView.m
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCGameBottomView.h"

@implementation SCGameBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"SCGameBottomView" owner:nil options:nil] firstObject]];
    }
    return self;
}

@end
