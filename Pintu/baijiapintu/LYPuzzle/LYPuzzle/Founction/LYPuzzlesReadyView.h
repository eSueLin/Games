//
//  LYPuzzlesReadyView.h
//  LYPuzzle
//
//  Created by HC16 on 2019/4/23.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^readiedtoPlay)(void);
@interface LYPuzzlesReadyView : UIView

- (instancetype)initWithImageName:(NSString *)imageName;

@property (nonatomic, copy) readiedtoPlay gameStart;

@end

NS_ASSUME_NONNULL_END
