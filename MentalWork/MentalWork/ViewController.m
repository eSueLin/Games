//
//  ViewController.m
//  MentalWork
//
//  Created by HC16 on 5/16/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "ViewController.h"
#import "MentalWorkViewController.h"
#import "MWData.h"
#import "ViewinRootVC/ViewinRootVCHeader.h"
#import "MentalWorkBGMusic.h"
#import "UIButton+ExpandHotZone.h"
#import "BYSystemVolum.h"


@interface ViewController ()<MentalWorkViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUnlockLevel];
    [self.view addSubview:[BYSystemVolum getSystemVolumeSlider]];
    [[MentalWorkBGMusic sharedInstance] turnOnBGM];
}


- (void)updateUnlockLevel {
    
    int unlockLevels = [[MWData defaultData] getUnLockLevel];
    if (unlockLevels == 1) {
        return;
    }
    for (int i = 0; i < unlockLevels; i++) {
        
        [self levelUnlock:i+1];
    }
}

- (IBAction)buttontoClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    int unlockLevels = [[MWData defaultData] getUnLockLevel];
    if (unlockLevels < btn.tag-100) {
        
        return;
    }
    
    MentalWorkViewController *mwVC = [[MentalWorkViewController alloc] init];
    mwVC.level = (int)btn.tag - 100;
    mwVC.delegate = self;
    
    [self presentViewController:mwVC animated:YES completion:nil];
}
- (IBAction)settingView:(id)sender {
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MentalWorkSettingView" owner:nil options:nil];
    MentalWorkSettingView *settingView = [nibs firstObject];
    settingView.frame = self.view.frame;
    settingView.settingVolum = ^(float volum) {
      
        //修改声音大小
        [[MentalWorkBGMusic sharedInstance] changeBGMVoice:volum];
        
    };
    [self.view addSubview:settingView];

//    [self performSelector:@selector(latertoShowSettingView:) withObject:settingView afterDelay:0.1];
}

- (IBAction)showHelpView:(id)sender {

    NSArray *nibsArr = [[NSBundle mainBundle] loadNibNamed:@"MentalWorkHelpView" owner:nil options:nil];
    MentalWorkHelpView *help = [nibsArr firstObject];
    help.frame = self.view.frame;
    [self.view addSubview:help];
}



//解锁关卡
- (void)levelUnlock:(int)level {
    
    UIButton *btn = [self.view viewWithTag:100+level];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level_%i",level]] forState:UIControlStateNormal];
}

#pragma mark - mentalwork viewcontroller delegate
- (void)mentalWorkGameOvertoUpdateUIWithLevel:(int)level {
    
    [self levelUnlock:level];
    
    [[MWData defaultData] saveUnLockLevel:level];
}



@end
