//
//  MentalWorkSettingView.h
//  MentalWork
//
//  Created by HC16 on 5/21/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MWSettingVoice)(float volum);
@interface MentalWorkSettingView : UIView

@property (nonatomic, copy) MWSettingVoice settingVolum;

@end

NS_ASSUME_NONNULL_END
