//
//  MWData.h
//  MentalWork
//
//  Created by HC16 on 5/19/19.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWData : NSObject

+ (MWData *)defaultData;

- (int)getUnLockLevel;

- (void)saveUnLockLevel:(int)unlocklevel ;

@end

NS_ASSUME_NONNULL_END
