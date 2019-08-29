//
//  SCGameViewController.h
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SCGameViewDelegate <NSObject>

- (void)gameViewtoRefreshHomeView:(int)updateLevel;

@end

@interface SCGameViewController : UIViewController

@property (nonatomic, weak) id<SCGameViewDelegate> delegate;
@property (nonatomic, assign) NSInteger level;

@end

NS_ASSUME_NONNULL_END
