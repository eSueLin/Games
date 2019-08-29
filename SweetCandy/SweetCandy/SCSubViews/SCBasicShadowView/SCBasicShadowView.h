//
//  SCBasicShadowView.h
//  SweetCandy
//
//  Created by HC16 on 5/30/19.
//  Copyright © 2019 SweetCandy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCTipViewType) {
    
    SCTipViewTypeHelp = 0,
    SCTipViewTypePass,
    SCTipViewTypeFail,
};
NS_ASSUME_NONNULL_BEGIN

typedef void(^ResponsetoControllerBlock)(BOOL isbackhome);
@interface SCBasicShadowView : UIView

@property (nonatomic, copy) ResponsetoControllerBlock shadowViewRespone;
@property (nonatomic, assign) NSInteger currentLevel;

- (void)showTipView:(SCTipViewType)tipViewType;

- (void)showPassTime:(NSString *)currentTime historyBest:(NSString*)bestTime;

@end

NS_ASSUME_NONNULL_END
