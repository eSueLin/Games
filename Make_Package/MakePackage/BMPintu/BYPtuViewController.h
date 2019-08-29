//
//  ViewController.h
//  BMPintu
//
//  Created by BirdMichael on 2019/2/14.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PtuViewControllerBlock)(NSInteger currentLevel);
@interface BYPtuViewController : UIViewController

/** 拼图等级 **/
@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) PtuViewControllerBlock refreshHomeViewStatus;

@end

