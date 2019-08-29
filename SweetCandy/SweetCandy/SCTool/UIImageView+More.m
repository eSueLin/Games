//
//  UIImageView+More.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "UIImageView+More.h"


@implementation UIImageView(More)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
__weak static id<UIImageViewGestureDelegate> delegate = nil;
- (void)imageViewForCheckersWithFrame:(CGRect)frame ImageName:(NSString *)imageName tag:(NSInteger)tag {
    
    [self setTag:tag];
    [self setFrame:frame];
    [self setImage:[UIImage imageNamed:imageName]];
    
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)];
    [panGes setMaximumNumberOfTouches:2];
    [panGes setDelegate:self];
    [self addGestureRecognizer:panGes];
}

- (void)setGestureDelegate:(id<UIImageViewGestureDelegate>)gestureDelegate {
    
    delegate = gestureDelegate;
}

- (id<UIImageViewGestureDelegate>)gestureDelegate {
    
    return delegate;
}


- (UIImageView *)normalWithFrame:(CGRect)frame ImageName:(NSString *)imageName tag:(NSInteger)tag {
    
    self.frame = frame;
    self.image = [UIImage imageNamed:imageName];
    self.tag   = tag;
    return self;
}

- (void)panMove:(UIGestureRecognizer *)sender {
    
    if ([self.gestureDelegate respondsToSelector:@selector(imageViewMovedWithGesture:)]) {
        
        [self.gestureDelegate imageViewMovedWithGesture:(UIPanGestureRecognizer*)sender];
    }
}


@end
