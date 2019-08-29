//
//  LYPuzzlesReadyView.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/23.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYPuzzlesReadyView.h"
#import "Toolbox.h"

@implementation LYPuzzlesReadyView
{
    
    NSString *_picName;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithImageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        
        _picName = imageName;
        [self setPuzzlesReadyUI];
    }
    return self;
}

static int beginningTime = 5;
- (void)setPuzzlesReadyUI {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *diImgV = [[UIImageView alloc] initWithFrame:self.frame];
    [diImgV setImage:[UIImage imageNamed:@"beijing"]];
    
    [self addSubview:diImgV];
    
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width-20, self.width-20)];
    imageView.center = self.center;
    [imageView setImage:[UIImage imageNamed:_picName]];
    [self addSubview:imageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top-40, self.width, 44)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment =NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"Complete the puzzle in a limited time";
    [self addSubview:tipLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    timeLabel.text = [NSString stringWithFormat:@"%i", beginningTime];
    timeLabel.font = [UIFont systemFontOfSize:30];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.center = CGPointMake(tipLabel.centerX, tipLabel.top-30);
    
    [self addSubview:timeLabel];
    [self performSelector:@selector(timeDown:) withObject:timeLabel afterDelay:1];
}

- (void)timeDown:(id)sender {
    
    UILabel *label = (UILabel *)sender;
    if (beginningTime !=1) {
        beginningTime--;
        label.text = [NSString stringWithFormat:@"%i", beginningTime];
        [self performSelector:@selector(timeDown:) withObject:label afterDelay:1];
    } else {

        label.text = @"Ready..";
        [self performSelector:@selector(readytoGoWithLabel:) withObject:label afterDelay:0.8];
    
    }
}

- (void)readytoGoWithLabel:(UILabel *)lab {
    
    lab.text = @"GO!";
    [self performSelector:@selector(closeBGView) withObject:nil afterDelay:0.8];
    beginningTime = 5;
}

- (void)closeBGView{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.origin = CGPointMake(0, self.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

        if (self.gameStart) {
            
            self.gameStart();
        }
    }];
    
}

@end
