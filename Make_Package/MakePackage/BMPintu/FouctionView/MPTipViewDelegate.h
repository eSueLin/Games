//
//  MPTipViewDelegate.h
//  Make_Package
//
//  Created by HC16 on 6/23/19.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#ifndef MPTipViewDelegate_h
#define MPTipViewDelegate_h

@protocol MPTipViewDelegate <NSObject>

- (void)tipViewtoReplay;

- (void)tipViewtoBackHome;

- (void)tipViewtoPlayNextStage;

- (void)tipViewtoClose;

@end


#endif /* MPTipViewDelegate_h */
