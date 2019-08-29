//
//  LYPuzzleCollectionView.m
//  LYPuzzle
//
//  Created by HC16 on 2019/4/23.
//  Copyright © 2019 HC16. All rights reserved.
//

#import "LYPuzzleCollectionView.h"
#import "Toolbox.h"

@interface LYPuzzleCollectionView()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@end
@implementation LYPuzzleCollectionView
{
    
    NSArray *_collectionVarr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)removeDataforCell:(NSIndexPath *)index {
    
    _collectionVarr = _dataSourceArray;
    NSArray<NSIndexPath *> *indexArr = [NSArray arrayWithObject:index];
    [self deleteItemsAtIndexPaths:indexArr];
}

- (void)puzzleCollectionViewInitData {
    
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:iCellResuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)loadDataWithDataSource:(NSMutableArray *)dataSourceArr {
    
    self.dataSourceArray = [NSMutableArray array];
    
    NSMutableArray *changedImgVsArr = [NSMutableArray arrayWithArray:dataSourceArr];
    
    do {
        NSUInteger rand = random()%changedImgVsArr.count;
        UIImageView *randImageV = changedImgVsArr[rand];
        randImageV.center = CGPointMake(randImageV.width/2, randImageV.height/2);
        
        [self.dataSourceArray addObject:randImageV];
        [changedImgVsArr removeObject:randImageV];
        [randImageV removeFromSuperview];
        
    } while (changedImgVsArr.count != 0);
    
    _collectionVarr = self.dataSourceArray;
    [self reloadData];
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iCellResuseIdentifier forIndexPath:indexPath];
    
    if ([cell.contentView subviews].count > 0) {
        
        if ([[cell.contentView subviews][0] isKindOfClass:[UIImageView class]]) {
            
            [[cell.contentView subviews][0] removeFromSuperview];
        }
    }
    
    UIImageView *imgV = _collectionVarr[indexPath.row];
    imgV.origin = CGPointMake(0, 0);
//    imgV.size = CGSizeMake(imgV.width*50/_ratioHeight, imgV.height*50/_ratioHeight);
//    imgV.layer.bounds = CGRectMake(0, 0, 40, 40);
    
    [cell.contentView addSubview:imgV];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _collectionVarr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *imgV = _collectionVarr[indexPath.row];
//    imgV.size = CGSizeMake(imgV.width*50/_ratioHeight, imgV.height*50/_ratioHeight);
    return imgV.size;
}






@end
