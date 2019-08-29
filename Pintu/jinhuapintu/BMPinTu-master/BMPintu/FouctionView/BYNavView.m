//
//  BYNavView.m
//  BMPintu
//
//  Created by HC16 on 2019/4/18.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BYNavView.h"

@implementation BYNavView

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
        [self setNavUI];
    }
    return self;
}

- (void)setNavUI {
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height+44);
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.frame];
    [imageV setImage:[UIImage imageNamed:@"frame_1"]];
    
    [self addSubview:imageV];
}

@end
