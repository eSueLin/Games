//
//  BGameOvew.h
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GameOverBlock)(BOOL isreplay);
@interface BGameOver : UIView

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (copy, nonatomic) GameOverBlock overblock;

@end

NS_ASSUME_NONNULL_END
