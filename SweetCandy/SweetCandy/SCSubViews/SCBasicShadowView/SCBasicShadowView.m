//
//  SCBasicShadowView.m
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCBasicShadowView.h"
#import "../SCHomeHelpView.h"
#import "../SCGamePassView.h"
#import "../SCGameOverView.h"

@implementation SCBasicShadowView

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
        
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:self.frame];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.4;
    
    [self addSubview:shadowView];
}

- (void)showTipView:(SCTipViewType)tipViewType{
    
    switch (tipViewType) {
        case SCTipViewTypeHelp:
        {
            [self showHelpView];
        }
            break;
        case SCTipViewTypePass:
        {
            [self showPassView];
        }
            break;
        case SCTipViewTypeFail:
        {
            [self showGameOverView];
        }
        break;
    }
}

- (void)showHelpView{
    
    SCHomeHelpView *homeTip = (SCHomeHelpView *)[self getNibViewWithNibName:@"SCHomeHelpView"];
    homeTip.frame = self.frame;
    __block typeof(self) shadowView = self;
    homeTip.responsetoCloseView = ^{
        
        [shadowView removeFromSuperview];
    };
    
    [self addSubview:homeTip];
}

- (void)showPassView {
    
    SCGamePassView *passTip = (SCGamePassView *)[self getNibViewWithNibName:@"SCGamePassView"];
    passTip.tag = 101;
    passTip.frame = self.frame;
    __block typeof(self) shadowView = self;
    passTip.buttonResponse = ^(BOOL isbackHome) {
      
        [shadowView removeFromSuperview];
        if (self.shadowViewRespone) {
            self.shadowViewRespone(isbackHome);
        }
    };
    
    [self addSubview:passTip];
    [passTip resetLevelShowed:self.currentLevel];
}

- (void)showGameOverView {
    
    SCGameOverView *overView = (SCGameOverView *)[self getNibViewWithNibName:@"SCGameOverView"];
    overView.frame = self.frame;
    
    __block typeof(self) shadow = self;
    overView.gameoverBtnRespone = ^(BOOL isHomeback) {
      
        [shadow removeFromSuperview];
        if (shadow.shadowViewRespone) {
            
            self.shadowViewRespone(isHomeback);
        }
        
    };
    [self addSubview:overView];
    [overView resetLevelShowed:self.currentLevel];
}

- (UIView *)getNibViewWithNibName:(NSString *)nibName {
    
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    return [arr firstObject];
}

- (void)showPassTime:(NSString *)currentTime historyBest:(NSString *)bestTime {
    
    SCGamePassView *pass = [self viewWithTag: 101];
    
    [pass refreshTimerWithCompleteTime:currentTime bestTime:bestTime];
}

@end
