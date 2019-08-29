//
//  HLResultView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/29.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLResultView.h"
#import "HLTool/HLToolbox.h"

#define SCREEN_RADIO_WIDTH [UIScreen mainScreen].bounds.size.width/414
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

@interface HLResultView()

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UIImageView *countImageView;

@end
@implementation HLResultView
{
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createView {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:self.frame];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.5;
    
    [self addSubview:alphaView];
}

- (void)resetView {
    
    
}

- (void)setFailedView {
    
    
}

- (void)setSuccessView {
    
    
}

- (void)refreshViewWithImageName:(NSString *)imageName countNum:(NSString *)numberImgName {
    
    [_levelImageView setImage:[UIImage imageNamed:imageName]];
    [_countImageView setImage:[UIImage imageNamed:numberImgName]];
}

- (IBAction)closeView:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)backtoHomeView:(id)sender {

    if (self.delegate) {
        
        [self.delegate resultViewtoBackHomeView];
    }
}

- (IBAction)restartGame:(id)sender {

    if (self.delegate) {
        [self removeFromSuperview];
        [self.delegate resultViewtoRestartGame];
    }
}

@end
