//
//  SCHomeHelpView.h
//  SweetCandy
//
//  Created by HC16 on 5/31/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CloseBlock)(void);
@interface SCHomeHelpView : UIView

@property (nonatomic, copy) CloseBlock responsetoCloseView;

@end

NS_ASSUME_NONNULL_END
