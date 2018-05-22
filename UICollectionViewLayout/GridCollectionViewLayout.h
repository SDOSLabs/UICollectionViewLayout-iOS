//
//  GridCollectionViewLayout.h
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 3/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const CollectionElementKindGridHeader;
extern NSString *const CollectionElementKindGridVerticalShadow;

@class GridCollectionViewLayout;

@protocol GridCollectionViewLayoutDelegate <UICollectionViewDelegate>

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForHeaderInLayout:(GridCollectionViewLayout *)collectionViewLayout;

@end

@interface GridCollectionViewLayout : UICollectionViewLayout

@end
