//
//  ViewController.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/16.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "ViewController.h"
#import "LYPuzzlePTViewController.h"
#import "LYDataMes/LYDataMesta.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSInteger _clickedBtnTag;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshHomeView];
}


- (IBAction)btntoClick:(id)sender {

    UIButton *btn = (UIButton *)sender;
    _clickedBtnTag = btn.tag;
    
    NSArray *passArr = [[LYDataMesta sharedInstance] getLevelsWithPassed];
    if (btn.tag-100 > passArr.count) {
        
        return;
    }
    
   
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LevelTime" ofType:@"plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
   
    NSDictionary *tagDic = [plistDict valueForKey:[NSString stringWithFormat:@"%ld", btn.tag]];
    NSInteger level = [tagDic[@"level"] integerValue];
    int time = [tagDic[@"time"] intValue];
    
    LYPuzzlePTViewController *ptvc = [[LYPuzzlePTViewController alloc] initWithNibName:@"LYPuzzlePTViewController" bundle:nil];
    ptvc.levelTotalTime = time;
    ptvc.gameLevel = level;
    ptvc.chosenStage = btn.tag;
    
    [self presentViewController:ptvc animated:YES completion:nil];

    __block typeof(self) vc = self;
    [LYDataMesta sharedInstance].newStagePassedRepord = ^(NSArray * _Nonnull updateArr) {
        
        [vc updateUIWithPassedStage:[updateArr.lastObject integerValue]-100];
    };
}


//获取新的游戏点
//打开新的关卡，连线跟关卡更换图片
- (void)passGameWithNewLevel {
    
    [self updateUIWithPassedStage:_clickedBtnTag-100+1];
}

- (void)updateUIWithPassedStage:(NSInteger)stage {
    
    NSInteger lineImgVTag =  stage + 10;
    
    UIImageView *lineImgV = [self.view viewWithTag:lineImgVTag];
    UIButton *btn = [self.view viewWithTag:stage+100];
    
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gq%ld", stage]] forState:UIControlStateNormal];
    [lineImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"line_%ld", stage]]];
}

//根据闯关个数，刷新界面
- (void)refreshHomeView {
    //获取闯关数
    NSArray *passedArr = [[LYDataMesta sharedInstance] getLevelsWithPassed];
    
    for (int i = 0;  i<passedArr.count; i++) {
        
        [self refreshStage:i+1];
    }
}

- (void)refreshStage:(NSInteger)stage {
    
    NSInteger lineImgVTag = stage + 10;
    UIImageView *line = [self.view viewWithTag:lineImgVTag];
    UIButton *btn = [self.view viewWithTag:stage+100];
    
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gq%ld", stage]] forState:UIControlStateNormal];
    [line setImage:[UIImage imageNamed:[NSString stringWithFormat:@"line_%ld", stage]]];
}
@end
