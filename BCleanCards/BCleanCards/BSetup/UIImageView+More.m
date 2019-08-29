//
//  UIImageView+More.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "UIImageView+More.h"

@class UIImageViewCheckersDelegate;
@implementation UIImageView(More)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
__weak static id<UIImageViewCheckersDelegate> delegate = nil;
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

- (void)setCheckersDelegate:(id<UIImageViewCheckersDelegate>)checkersDelegate {
    
     delegate = checkersDelegate;
    
}

- (id<UIImageViewCheckersDelegate>)checkersDelegate {
    
    return delegate;
}

- (UIImageView *)normalWithFrame:(CGRect)frame ImageName:(NSString *)imageName tag:(NSInteger)tag {
    
    self.frame = frame;
    self.image = [UIImage imageNamed:imageName];
    self.tag   = tag;
    return self;
}

- (void)panMove:(UIGestureRecognizer *)sender {
    
    if ([self.checkersDelegate respondsToSelector:@selector(checkersChessmanMoveWithGesture:)]) {
        
        [self.checkersDelegate checkersChessmanMoveWithGesture:(UIPanGestureRecognizer*)sender];
    }
}


@end
