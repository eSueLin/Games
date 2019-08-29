//
//  ViewController.m
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "ViewController.h"
#import "HLTool/HLToolbox.h"
#import "HLBaseViewController.h"
#import "HLLevelSeclectionView.h"

@interface ViewController ()<HLLevelSelectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [self createUI];
        // Do any additional setup after loading the view, typically from a nib.
        NSLog(@"gone@!!");
        HLGreenCheckerView *chessPlateformView = [[HLGreenCheckerView alloc] init];
        chessPlateformView.isHomePage = YES;
        [chessPlateformView setImageViewforCheckerboard];
        chessPlateformView.center = self.view.center;
        chessPlateformView.centerY = self.view.centerY + (chessPlateformView.width - 8)/8/4;
        
        [self.view addSubview:chessPlateformView];
    });
}

- (void)createUI {
    
//    [self.bgImageView setFrame:[UIScreen mainScreen].bounds];
    
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 44) {
        
        [self.bgImageView setImage:[UIImage imageNamed:@"bg_iphonex"]];
    }
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"HLLevelSeclectionView" owner:nil options:nil];
    HLLevelSeclectionView *view = [viewArray firstObject];
    view.delegate = self;
    view.tag = 100;
    view.centerX = self.view.centerX;
    [self.view addSubview:view];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue];
    [self.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LEVEL%ld", arr.count]]];
}

- (void)levelSelectedtoEnterGameWithGameLevelType:(GameLevelType)type {
    
    HLBaseViewController *gameVC = [[HLBaseViewController alloc] init];
    gameVC.gameLevel = type;
    
    __block typeof(self) viewc = self;
    gameVC.statusChange = ^{
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue];
        [viewc.levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"LEVEL%ld", arr.count]]];
    };
    
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (IBAction)homeViewStartGame:(id)sender {

    NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:kGamePassStatue];
    
    [self levelSelectedtoEnterGameWithGameLevelType:[arr.lastObject integerValue]];
}




@end
