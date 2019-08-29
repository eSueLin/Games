//
//  HLLevelSeclectionView.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/28.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "HLLevelSeclectionView.h"
#import "HLTool/HLToolbox.h"

@interface HLLevelSeclectionView()

@property (weak, nonatomic) IBOutlet UIButton *firstLevel;
@property (weak, nonatomic) IBOutlet UIButton *secorndLevel;
@property (weak, nonatomic) IBOutlet UIButton *thirdLevel;
@property (weak, nonatomic) IBOutlet UIButton *forthLevel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *lastViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextViewBtn;

@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@end

@implementation HLLevelSeclectionView

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
//        [self createLevelSelectionView];
    }
    return self;
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self createLevelSelectionView];
    
}
- (void)createLevelSelectionView {
    
//    view.centerX = self.view.centerX;
//    view.width = [UIScreen mainScreen].bounds.size.width*0.8;
//    view.height = view.width/300 * 80;
    
    int pointx = [UIScreen mainScreen].bounds.size.width*1/10;
    int width  = [UIScreen mainScreen].bounds.size.width*4/5;
    int pointy = (60+[UIApplication sharedApplication].statusBarFrame.size.height)*[UIScreen mainScreen].bounds.size.height/667;
    int height = 80;
    
    [self setFrame:CGRectMake(pointx, pointy, width, height)];
//    self.centerX = [UIScreen mainScreen].bounds.size.width/2+10;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    
    for (int i = 0; i < 6; i++) {
        
        if (i >= 4) {
            
            UIButton *lastBtn = [self.scrollView viewWithTag:20+i-1];
            
            UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            newBtn.tag = 20+i;
            [newBtn setImage:[UIImage imageNamed:@"锁定"] forState:UIControlStateNormal];
            newBtn.frame = lastBtn.frame;
            [self.scrollView addSubview:newBtn];
            
            [newBtn addTarget:self action:@selector(levelSelcted:) forControlEvents:UIControlEventTouchUpInside];
            newBtn.centerX = lastBtn.centerX+lastBtn.width+14;
            newBtn.centerY = lastBtn.centerY;
        }
    }
    
    
    [LHGamePass sharedInstance];
    
    __block typeof(self) selectionBlock = self;
    [LHGamePass sharedInstance].refreshStatus = ^{
        
        [selectionBlock showGameBtnWithStatus];
    };
    
    [self showGameBtnWithStatus];
    
    self.scrollContentView.width = self.scrollView.width;
    self.scrollContentView.height = self.scrollView.height;
}

- (void)showGameBtnWithStatus {
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue];
    NSArray *imageArr = @[@"未锁定", @"yellow", @"white", @"green", @"blue", @"org"];
    
//    NSLog(@"arr:%@", arr);
    for (int i = 0; i < arr.count; i++) {
        
        UIButton *btn = [self.scrollView viewWithTag:20+i];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        
    }
}

- (void)selectionViewWillAppearFromOtherPage {
    
    if (!self.nextViewBtn.enabled) {
        [self setScrollViewContenOffsetForNextViewBtn];
    }
}

//上一页
- (IBAction)pagetoLastView:(id)sender {

    self.nextViewBtn.enabled = YES;
    self.scrollView.contentOffset =  CGPointZero;
    self.lastViewBtn.enabled = NO;
}

- (IBAction)pagetoNextView:(id)sender {
    
    self.lastViewBtn.enabled = YES;
    self.nextViewBtn.enabled = NO;
    [self setScrollViewContenOffsetForNextViewBtn];
}

- (void)setScrollViewContenOffsetForNextViewBtn {
    
    UIButton *gamebtn = [self.scrollView viewWithTag:20];
    int showBtnNum = (self.scrollView.width-gamebtn.width)/(gamebtn.width+14)+1;
    CGFloat pointx = gamebtn.left+(gamebtn.width+14)*(6-showBtnNum);
    self.scrollView.contentOffset = CGPointMake(pointx, 0);
}


- (IBAction)levelSelcted:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    
    GameLevelType type;
    switch (btn.tag) {
        case 20:
        {
            type = GameLevelTypeFirst;
        }
            break;
        case 21:
        {
            type = GameLevelTypeSecond;
        }
            break;
        case 22:
        {
            type = GameLevelTypeThird;
        }
            break;
        case 23:
        {
            type = GameLevelTypeForth;
        }
            break;
        case 24:
        {
            type = GameLevelTypeFifth;
        }
            break;
        case 25:
        {
            type = GameLevelTypeSixth;
        }
            break;
        default:
        {
            type = GameLevelTypeForth;
        }
            break;
    }
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue];
    if (arr.count-1+20 < btn.tag) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(levelSelectedtoEnterGameWithGameLevelType:)]) {
        
        [self.delegate levelSelectedtoEnterGameWithGameLevelType:type];
    }
}


@end
