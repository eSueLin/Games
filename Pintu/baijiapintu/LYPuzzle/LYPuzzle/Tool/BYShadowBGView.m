//
//  BYShadowBGView.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BYShadowBGView.h"

@implementation BYShadowBGView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setShadowBgg];
    }
    return self;
}

- (void)setShadowBgg {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.frame];

    alphaView.backgroundColor = UIColor.blackColor;
    alphaView.alpha = 0.4;

    [self addSubview:alphaView];
}

@end
