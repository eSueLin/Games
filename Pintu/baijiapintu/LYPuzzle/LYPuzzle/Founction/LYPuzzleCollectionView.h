//
//  LYPuzzleCollectionView.h
//  LYPuzzle
//
//  Created by HC16 on 2019/4/23.
//  Copyright © 2019 HC16. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *iCellResuseIdentifier = @"puzzleCell";

@interface LYPuzzleCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) CGFloat  ratioHeight;

- (void)puzzleCollectionViewInitData;

- (void)loadDataWithDataSource:(NSMutableArray *)dataSourceArr;

- (void)removeDataforCell:(NSIndexPath*)index;


@end

NS_ASSUME_NONNULL_END
