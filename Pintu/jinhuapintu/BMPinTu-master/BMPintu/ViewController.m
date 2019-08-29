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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBgView];
    
    [self setUI];
    
    [self registerGameCenter];
}

- (void)registerGameCenter {
    
    [[BYGameCenterInt gameCenter] authenticateLocalPlayer];
}

- (void)setUI {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, 0, 230*[UIScreen mainScreen].bounds.size.height/667, 100*[UIScreen mainScreen].bounds.size.height/667);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btntoClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"derg_2"] forState:UIControlStateNormal];
    
    button.tag = 101;
    button.center = CGPointMake(self.view.centerX, self.view.centerY+60*[UIScreen mainScreen].bounds.size.height/667);
    
    UIButton *thBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [thBtn setButtonWithFrame:button.frame title:@"" titleColor:[UIColor blackColor] Target:self action:@selector(btntoClick:)];
    thBtn.tag = 100;
    thBtn.center = CGPointMake(button.centerX, button.top - 60*[UIScreen mainScreen].bounds.size.height/667);
    [thBtn setBackgroundImage:[UIImage imageNamed:@"dyg_1"] forState:UIControlStateNormal];
    
    UIButton *fivBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fivBtn setButtonWithFrame:button.frame title:@"" titleColor:[UIColor blackColor] Target:self action:@selector(btntoClick:)];
    fivBtn.tag = 102;
    fivBtn.center = CGPointMake(button.centerX, button.bottom + 60*[UIScreen mainScreen].bounds.size.height/667);
    [fivBtn setBackgroundImage:[UIImage imageNamed:@"dsg_3"] forState:UIControlStateNormal];
    
    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rankBtn setButtonWithFrame:button.frame title:@"" titleColor:[UIColor blackColor] Target:self action:@selector(showRanking)];
    rankBtn.center = CGPointMake(rankBtn.centerX, fivBtn.bottom+60*[UIScreen mainScreen].bounds.size.height/667);
    [rankBtn setBackgroundImage:[UIImage imageNamed:@"phb_1"] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    [self.view addSubview:thBtn];
    [self.view addSubview:fivBtn];
    [self.view addSubview:rankBtn];
}

- (void)setBgView {
    
    UIImageView *bgV = [[UIImageView alloc] initWithFrame:self.view.frame];
    [bgV setImage:[UIImage imageNamed:@"bg1"]];
    [self.view addSubview:bgV];
}

- (void)btntoClick:(UIButton *)sender {
    
    int level = 0;
    
    switch (sender.tag) {
        case 100:
            level = 3;
            break;
        case 101:
            level = 4;
            break;
        case 102:
            level = 5;
            break;
        default:
            break;
    }
    
    BYPtuViewController *ptVC = [[BYPtuViewController alloc] init];
    ptVC.level = level;
    [self presentViewController:ptVC animated:YES completion:nil];
}

- (void)showRanking {
    
    [[BYGameCenterInt gameCenter] showRankListWithCurrentVC:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
