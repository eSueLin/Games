//
//  BRecordView.h
//  BCleanCards
//
//  Created by HC16 on 5/15/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BRecordblock)(BOOL isbacktoHome);
@interface BRecordView : UIView

@property (nonatomic, copy) BRecordblock recordAction;

@end

NS_ASSUME_NONNULL_END
