//
//  ViewController.m
//  BCleanCards
//
//  Created by HC16 on 5/9/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "ViewController.h"
#import "BSecondViewControllers/BSecondVCsHeader.h"
#import "BSecondViewControllers/BViews/BRecordView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - button click

- (IBAction)gameStart:(id)sender {

    BGameViewController *gameVC = [[BGameViewController alloc] init];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (IBAction)gameDescription:(id)sender {

    BHelpViewController *helpVC = [[BHelpViewController alloc] init];
    [self presentViewController:helpVC animated:YES completion:nil];
}

- (IBAction)gameHistoryScore:(id)sender {
    
    NSArray *nibsArr = [[NSBundle mainBundle] loadNibNamed:@"BRecordView" owner:nil options:nil];
    BRecordView *recordV = [nibsArr firstObject];
    recordV.frame = self.view.frame;
    recordV.recordAction = ^(BOOL isbacktoHome) {
        
    };
    
    [self.view.window addSubview:recordV];
}


@end
