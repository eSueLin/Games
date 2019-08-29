//
//  ViewController.m
//  BMPintu
//
//  Created by HC16 on 2019/4/12.
//  Copyright © 2019 BM. All rights reserved.
//

#import "ViewController.h"
#import "BYPtuViewController.h"
#import "UIView+Additions.h"
#import "UIButton+Additions.h"
#import "BYGameCenterInt.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UIButton *levelOneBtn;


@end

@implementation ViewController
{
    UIButton *lastBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)initView {
    
    [self setSelectedLayer:self.levelOneBtn];
    lastBtn = self.levelOneBtn;

    for (int i = 0; i < 3; i++) {

        UIButton *btn = [self.view viewWithTag:20+i];
        btn.layer.cornerRadius = 3;
    }
    
}

- (IBAction)buttontoClick:(id)sender {
    
    if (lastBtn) {
        [self removeLayerEffect:lastBtn];
    }
    
    UIButton *btn = (UIButton *)sender;
    [self setSelectedLayer:btn];
    
    [self.showImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lev_image%ld", btn.tag-20+1]]];
    
    lastBtn = btn;
}

- (IBAction)startToPlay:(id)sender {
    
    
    BYPtuViewController *ptVC = [[BYPtuViewController alloc] init];
    ptVC.level = lastBtn.tag-20+1;
    
    __block typeof(self) blockSelf = self;
    ptVC.refreshHomeViewStatus = ^(NSInteger currentLevel) {
      
        NSInteger tag = currentLevel+20-1;
        if (blockSelf->lastBtn.tag != tag) {
            
            UIButton *btn = [blockSelf.view viewWithTag:tag];
            [blockSelf buttontoClick:btn];
        }
    };
    
    [self presentViewController:ptVC animated:YES completion:nil];
}

- (void)setSelectedLayer:(UIButton *)btn {
    
    CALayer *layer = [[CALayer alloc] init];
    layer = btn.layer;
    layer.borderColor = [UIColor yellowColor].CGColor;
    layer.borderWidth = 2.5;
    
    layer.shadowColor = [UIColor yellowColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 10;
    layer.shadowOpacity = 1;
}

//移除layer渲染框
- (void)removeLayerEffect:(UIButton *)btn {
    
    CALayer *layer = btn.layer;
    layer.borderWidth = 0;
    layer.shadowRadius = 0;
}


- (void)registerGameCenter {
    
    [[BYGameCenterInt gameCenter] authenticateLocalPlayerWithSuperVC:self];
}


- (void)showRanking {
    
    [[BYGameCenterInt gameCenter] showRankListWithCurrentVC:self];
}


@end
