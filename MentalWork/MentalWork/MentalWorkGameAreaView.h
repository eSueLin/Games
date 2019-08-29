//
//  MentalWorkGameAreaView.h
//  MentalWork
//
//  Created by HC16 on 5/20/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MentalWorkGameAreaViewDelegate <NSObject>

- (void)mwGameAreaCleaning;

- (void)mwGameAreaCompleted;

@end

@interface MentalWorkGameAreaView : UIView

@property (nonatomic, weak) id<MentalWorkGameAreaViewDelegate> delegate;

- (void)createGameAreaWithVer:(int)ki hor:(int)kj;

- (instancetype)initWithGameArearView:(UIView *)gameArea level:(int)level imageNames:(NSMutableArray *)imageNames;

@end

NS_ASSUME_NONNULL_END
