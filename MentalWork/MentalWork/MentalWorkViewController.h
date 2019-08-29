//
//  MentalWorkViewController.h
//  MentalWork
//
//  Created by HC16 on 5/16/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MentalWorkViewControllerDelegate <NSObject>

- (void)mentalWorkGameOvertoUpdateUIWithLevel:(int)level;

@end

@interface MentalWorkViewController : UIViewController

@property (nonatomic, assign) int level;

@property (nonatomic, weak) id<MentalWorkViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
