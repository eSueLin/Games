//
//  MentalWorkHelpView.m
//  MentalWork
//
//  Created by HC16 on 5/21/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "MentalWorkHelpView.h"
#import "../UIView+Additions.h"
@interface MentalWorkHelpView ()<UIGestureRecognizerDelegate>

@end
@implementation MentalWorkHelpView
{
    
    __weak IBOutlet UIView *shadowView;
    __weak IBOutlet UIImageView *helpImageV;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [shadowView addGestureRecognizer:tap];
}

- (void)tap {
    
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint locPoint = [touch locationInView:self];
    if (locPoint.x > helpImageV.left && locPoint.x<helpImageV.right && locPoint.y > helpImageV.top && locPoint.y < helpImageV.bottom) {
        
        return NO;
    }
    
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
