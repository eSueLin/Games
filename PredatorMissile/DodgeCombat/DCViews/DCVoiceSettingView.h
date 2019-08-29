//
//  DCVoiceSettingView.h
//  DodgeCombat
//
//  Created by HC16 on 6/11/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DCVoiceSettingBlock)(void);
typedef void(^DCVolumChangingBlock)(float volum);

@interface DCVoiceSettingView : UIView

@property (nonatomic, copy) DCVoiceSettingBlock closeSettingView;

@property (nonatomic, copy) DCVolumChangingBlock volumChanging;


@end

NS_ASSUME_NONNULL_END
