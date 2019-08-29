//
//  LYGameResultDelegate.h
//  LYPuzzle
//
//  Created by HC16 on 2019/5/6.
//  Copyright © 2019 HC16. All rights reserved.
//

#ifndef LYGameResultDelegate_h
#define LYGameResultDelegate_h

@protocol LYGameResultDelegate <NSObject>

- (void)resulttoReplayGame:(id)sender;

- (void)resultFailedtoPlayLastLevelGame:(id)sender;

- (void)resulttoPlayNextLevelGame:(id)sender;

- (void)resulttoExitGame;
@end


#endif /* LYGameResultDelegate_h */
