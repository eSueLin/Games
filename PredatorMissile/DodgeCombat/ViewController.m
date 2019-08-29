//
//  ViewController.m
//  DodgeCombat
//
//  Created by HC16 on 5/24/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "ViewController.h"
#import "DCGameViewController.h"
#import "DCViews/DCViewsHeader.h"
#import "DCRules/DCRulesHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [BYSystemVolum sharedVolum];
    [[DCBackgroundMusic defaultMusic] turnonMusic];
    [BYGameCenterInt gameCenter];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.view addSubview:[BYSystemVolum getSystemVolumeSlider]];

}

- (IBAction)homeViewBtnClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 101:
        {
            DCGameViewController *dc = [[DCGameViewController alloc] initWithNibName:@"DCGameViewController" bundle:nil];
            
            dc.levelonGame = 1;
            
            [self presentViewController:dc animated:YES completion:nil];
            
        }
            break;
        case 102:
        {
            [[BYGameCenterInt gameCenter] showRankListWithCurrentVC:self];
        }
            break;
        case 103:
        {
            DCVoiceSettingView *settingView = (DCVoiceSettingView *)[[[NSBundle mainBundle] loadNibNamed:@"DCVoiceSettingView" owner:nil options:nil] firstObject];
            
            settingView.volumChanging = ^(float volum) {
                
                [[DCBackgroundMusic defaultMusic] changeBGMVoice:volum];
            };
            
            settingView.frame = self.view.frame;
            [self.view addSubview:settingView];
        }
            break;
        default:
            break;
    }
}


@end
