//
//  HLCheckersView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLCheckersView.h"

@implementation HLCheckersView

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
        
        [self dataInit];
    }
    return self;
}

- (void)dataInit{
    
    self.rules = [[HLCheckersRules alloc] init];
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20);
    self.tag = 11;
}

- (void)setImageViewforCheckerboard {
    
    
}

- (void)restartGame {
    
    [self.rules.checkerboardMutaArray removeAllObjects];
    [self.rules.chessmenMutaArray removeAllObjects];
}


@end
