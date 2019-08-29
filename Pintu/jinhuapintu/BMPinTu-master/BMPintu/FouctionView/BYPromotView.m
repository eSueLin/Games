//
//  BYPromotView.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BYPromotView.h"
#import "UIView+Additions.h"
#import "UIButton+Additions.h"
#import "BYGameCenterInt.h"

@implementation BYPromotView

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
        
    }
    return self;
}

- (void)setPromoteView {
    
    self.frame = CGRectMake(0, 0, 240, 180);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"赞！拼图完成";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 120, 44);
    label.center = CGPointMake(self.width/2, self.height/2-20);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setButtonWithFrame:CGRectMake(0, 0, 80, 44) title:@"重新开始" titleColor:[UIColor blackColor] Target:self action:@selector(toreStartPlay:)];
    [btn resetViewWithLayer];
    [btn setFont:[UIFont systemFontOfSize:15]];
    btn.center = CGPointMake(self.width/2, self.height - 40);
    
    UIButton *closeViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeViewBtn setButtonWithFrame:CGRectMake(0, 0, 44, 44) title:@"关闭" titleColor:[UIColor blackColor] Target:self action:@selector(removeSelfView)];
    
    closeViewBtn.center = CGPointMake(self.width-40, 20);
    closeViewBtn.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:label];
    [self addSubview:btn];
    [self addSubview:closeViewBtn];
}

//重新开始游戏
- (IBAction)reStartGame:(id)sender {

    [self toreStartPlay:sender];
}

//退出游戏
- (IBAction)backtoFirstPage:(id)sender {

    [self removeSelfView];
}

- (IBAction)closeResultView:(id)sender {
    
    [self removeSelfView];
}

- (void)removeSelfView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closePromotView)]) {
        
        [self.delegate closePromotView];
        [self removeFromSuperview];
    }
}

- (void)toreStartPlay:(id)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(promotetoPlay)]) {
        
        [self.delegate promotetoPlay];
        [self removeFromSuperview];
    }
}


@end
