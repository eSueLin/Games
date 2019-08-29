//
//  MentalWorkCompleteView.h
//  MentalWork
//
//  Created by HC16 on 5/18/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MentalWorkGameResultDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface MentalWorkCompleteView : UIView

@property (nonatomic, weak) id<MentalWorkGameResultDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
