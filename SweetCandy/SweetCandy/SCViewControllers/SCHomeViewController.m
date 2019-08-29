//
//  SCHomeViewController.m
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "SCHomeViewController.h"
#import "../SCSubViews/SCBasicShadowView/SCBasicShadowView.h"
#import "SCGameViewController.h"

@interface SCHomeViewController ()<SCGameViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *stageImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *stageSelectedScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIButton *stageSelectedBtn;
@property (weak, nonatomic) IBOutlet UIView *stageSelectBottomView;

@end

@implementation SCHomeViewController
{
    UIButton *lastSectedBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@">>>>>it gone");
    if (!lastSectedBtn) {
        lastSectedBtn = [self.scrollContentView viewWithTag:201];
        
    }
}

- (IBAction)stageSelected:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    [self.stageImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"le%ld", btn.tag-200]]];
    
    if (lastSectedBtn.tag == 201 || lastSectedBtn.tag == 206) {
        
        for (int i = 0 ; i<2; i++) {
            
            UIButton *ibtn = [self.stageSelectBottomView viewWithTag:211+i];
            ibtn.enabled = YES;
        }
    }
    
    if (btn.tag == 206) {
        
        UIButton *rightbtn = [self.stageSelectBottomView viewWithTag:212];
        rightbtn.enabled = NO;
    } else if (btn.tag == 201) {
        
        UIButton *leftbtn = [self.stageSelectBottomView viewWithTag:211];
        leftbtn.enabled = NO;
    }
    
    lastSectedBtn.enabled = YES;
    btn.enabled = NO;
    lastSectedBtn = btn;
    _newestLevel = 0;
}

- (IBAction)scrollingMore:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%f", self.scrollContentView.frame.origin.x);
    NSLog(@"%f", self.stageSelectedScrollView.contentOffset.x);
    if (btn.tag == 211) {
        
        if (btn.enabled) {
            
            if (self.stageSelectedScrollView.contentOffset.x != 0) {

                self.stageSelectedScrollView.contentOffset = CGPointMake(self.stageSelectedScrollView.contentOffset.x-self.stageSelectedBtn.frame.size.width, 0);
            }
            
            if (lastSectedBtn.tag > 201) {
              
                UIButton *lastbtn = [self.scrollContentView viewWithTag:lastSectedBtn.tag-1];
                [self stageSelected:lastbtn];
                if (lastSectedBtn.tag == 201) {
                    btn.enabled = NO;
                }
            }
            
            UIButton *rightBtn = [self.stageSelectBottomView viewWithTag:212];
            if (!rightBtn.enabled) {
                rightBtn.enabled = YES;
            }
        }
        
    } else { //212
        
        if (!lastSectedBtn) {
            lastSectedBtn = [self.scrollContentView viewWithTag:201];
        }
        //scrollView位置偏移
        if (lastSectedBtn.tag >= 204) {
            
            self.stageSelectedScrollView.contentOffset = CGPointMake((lastSectedBtn.tag-204+1)*self.stageSelectedBtn.frame.size.width, 0);
        }
        
        if (lastSectedBtn.tag < 206) {
           
            if (lastSectedBtn.tag == 205) {
                btn.enabled = NO;
            }
            UIButton *nextbtn = [self.scrollContentView viewWithTag:lastSectedBtn.tag+1];
            [self stageSelected:nextbtn];
        }
        
        UIButton *leftBtn = [self.stageSelectBottomView viewWithTag:211];
        if (!leftBtn.enabled) {
            leftBtn.enabled = YES;
        }
    }
}

- (IBAction)showHelp:(id)sender {
    
    SCBasicShadowView *tipView = [[SCBasicShadowView alloc] init];
    
    [tipView showTipView:SCTipViewTypeHelp];
    
    [self.view addSubview:tipView];
}

- (IBAction)startGame:(id)sender {

    SCGameViewController *game = [[SCGameViewController alloc] initWithNibName:@"SCGameViewController" bundle:nil];
    game.level = lastSectedBtn.tag-200;
    game.delegate = self;
    [self presentViewController:game animated:YES completion:nil];
}

static int _newestLevel = 0;
- (void)gameViewtoRefreshHomeView:(int)updateLevel {
    
    _newestLevel = updateLevel;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_newestLevel) {
        
        lastSectedBtn.enabled = YES;
        UIButton *btn = [self.scrollContentView viewWithTag:200+_newestLevel];
        [self.stageImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"le%d", _newestLevel]]];

        btn.enabled = NO;
        lastSectedBtn = btn;
    }
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
