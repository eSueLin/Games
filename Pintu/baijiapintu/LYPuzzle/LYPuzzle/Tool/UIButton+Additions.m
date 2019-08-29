//
//  UIButton+Additions.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BM. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton (Additions)

- (void)setButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color Target:(id)targer action:(SEL)selector {
    
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self addTarget:targer action:selector forControlEvents:UIControlEventTouchUpInside];

}


@end
