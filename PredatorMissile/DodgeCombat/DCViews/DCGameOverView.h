//
//  DCGameOverView.h
//  DodgeCombat
//
//  Created by HC16 on 6/11/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DCGameOverEventRespone)(BOOL isBackHome);
@interface DCGameOverView : UIView

@property (nonatomic, copy) DCGameOverEventRespone eventRespone;

- (void)showScore:(int)score;

@end

NS_ASSUME_NONNULL_END
