//
//  ViewController.m
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import "ViewController.h"

#import "SCViewControllers/SCHomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    SCHomeViewController *homeVC = [[SCHomeViewController alloc] initWithNibName:@"SCHomeViewController" bundle:nil];
    
    [self presentViewController:homeVC animated:NO completion:nil];
}

@end
