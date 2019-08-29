//
//  UIImageView+More.h
//  HLCheckers
//
//  Created by HC16 on 2019/4/25.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UIImageViewGestureDelegate <NSObject>

- (void)imageViewMovedWithGesture:(UIPanGestureRecognizer *)ges;

@end

@interface UIImageView(More)<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<UIImageViewGestureDelegate> gestureDelegate;

- (void)imageViewForCheckersWithFrame:(CGRect)frame ImageName:(NSString *)imageName tag:(NSInteger)tag;

/** normal init **/
- (UIImageView *)normalWithFrame:(CGRect)frame ImageName:(NSString *)imageName tag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
