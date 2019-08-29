//
//  UIButton+ExpandHotZone.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "UIButton+ExpandHotZone.h"
//#import <>

@implementation UIButton (ExpandHotZone)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
//    objc_ass
    CGRect bounds = self.bounds;
    // 若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat deltaW = MAX(44 - bounds.size.width, 0);
    CGFloat deltaH = MAX(44 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -deltaW * 0.5, -deltaH * 0.5);
    return CGRectContainsPoint(bounds, point);
}

@end
