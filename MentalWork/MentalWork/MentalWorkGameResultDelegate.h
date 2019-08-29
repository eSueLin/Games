//
//  MentalWorkGameResultDelegate.h
//  MentalWork
//
//  Created by HC16 on 5/18/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#ifndef MentalWorkGameResultDelegate_h
#define MentalWorkGameResultDelegate_h

@protocol MentalWorkGameResultDelegate <NSObject>

- (void)mentalWorktoBackHome;

- (void)mentalWorktoRestartGame;

- (void)mentalWorktoNextGame;

@end

#endif /* MentalWorkGameResultDelegate_h */
