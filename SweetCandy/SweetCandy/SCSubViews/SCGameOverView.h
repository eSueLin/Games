//
//  SCGameOverView.h
//  SweetCandy
//
//  Created by HC16 on 6/4/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GameoverRespone)(BOOL isHomeback);
@interface SCGameOverView : UIView

@property (nonatomic, copy) GameoverRespone gameoverBtnRespone;

- (void)resetLevelShowed:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
