//
//  UIButton+Additions.h
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Additions)

- (void)setButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color Target:(id)targer action:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
