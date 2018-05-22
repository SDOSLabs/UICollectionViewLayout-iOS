//
//  GridCollectionViewLayout.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 3/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "GridCollectionViewLayout.h"

#define ZINDEX_ITEMS 500
#define ZINDEX_SHADOW 750
#define ZINDEX_FIRST_COL_ITEMS 1000

#define ITEM_WIDTH 70
#define ITEM_HEIGHT 40

NSString *const CollectionElementKindGridHeader = @"CollectionElementKindGridHeader";
NSString *const CollectionElementKindGridVerticalShadow = @"CollectionElementKindGridVerticalShadow";

@interface GridCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *itemAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *shadowAttributes;
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation GridCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.itemAttributes) {
        return;
    }
    
    [self generateItemAttributes];
    [self generateShadowAttributes];
    [self generateHeaderAttributes];
}

- (void)generateItemAttributes {
    self.itemAttributes = [NSMutableArray array];
    
    CGFloat xOffset = 0;
    CGFloat yOffset = [self headerHeight];
    
    NSUInteger numberOfColumns = [self.collectionView numberOfSections];
    NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    for (int row = 0; row < numberOfRows; row++) {
        
        NSMutableArray *sectionAttributes = [NSMutableArray array];
        for (NSUInteger column = 0; column < numberOfColumns; column++) {
            // Creamos UICollectionViewLayoutAttributes para cada elemento y los añadimos al array de atributos. Lo utilizaremos después
            // para layoutAttributesForElementsInRect: y layoutAttributesForItemAtIndexPath:
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:column];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, ITEM_WIDTH, ITEM_HEIGHT));
            
            if (column == 0) {
                attributes.zIndex = ZINDEX_FIRST_COL_ITEMS;
            } else {
                attributes.zIndex = ZINDEX_ITEMS;
            }
            
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset + ITEM_WIDTH;
        }
        
        xOffset = 0;
        yOffset = yOffset + ITEM_HEIGHT;
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // Calculamos el contentSize a partir de los atributos del último elemento
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    CGFloat contentWidth = attributes.frame.origin.x + attributes.frame.size.width;
    CGFloat contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)generateShadowAttributes {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:CollectionElementKindGridVerticalShadow withIndexPath:indexPath];
    attributes.frame = CGRectIntegral(CGRectMake(0, [self headerHeight], ITEM_WIDTH, self.contentSize.height));
    attributes.zIndex = ZINDEX_SHADOW;
    self.shadowAttributes = attributes;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (void)generateHeaderAttributes {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CollectionElementKindGridHeader withIndexPath:indexPath];
    attributes.frame = CGRectIntegral(CGRectMake(0, 0, self.contentSize.width, [self headerHeight]));
    self.headerAttributes = attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    
    [attributes addObject:self.shadowAttributes];
    
    if (CGRectIntersectsRect(rect, self.headerAttributes.frame)) {
        [attributes addObject:self.headerAttributes];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath.row][indexPath.section];
}

#pragma mark - Invalidation

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    [self updatePinnedItemsAttributesForBoundsChange:newBounds];
    return YES;
}

- (void)updatePinnedItemsAttributesForBoundsChange:(CGRect)newBounds {
    NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    NSUInteger numberOfColumns = [self.collectionView numberOfSections];
    for (int row = 0; row < numberOfRows; row++) {
        for (NSUInteger column = 0; column < numberOfColumns; column++) {
            if (column != 0) {
                continue;
            }
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:column]];
            if (column == 0) { // Fijamos los elementos de la primera columna
                CGRect frame = attributes.frame;
                frame.origin.x = newBounds.origin.x;
                attributes.frame = frame;
            }
        }
    }
    
    CGRect shadowFrame = self.shadowAttributes.frame;
    if (newBounds.origin.x > 0) {
        shadowFrame.origin.x = newBounds.origin.x + ITEM_WIDTH - 1;
        self.shadowAttributes.zIndex = ZINDEX_SHADOW;
    } else {
        shadowFrame.origin.x = 0;
        self.shadowAttributes.zIndex = 0;
    }
    self.shadowAttributes.frame = shadowFrame;
    
    CGRect headerFrame = self.headerAttributes.frame;
    headerFrame.origin.x = newBounds.origin.x;
    self.headerAttributes.frame = headerFrame;
}

#pragma mark - Helper methods

- (CGFloat)headerHeight {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:heightForHeaderInLayout:)]) {
        return [(id<GridCollectionViewLayoutDelegate>)self.collectionView.delegate collectionView:self.collectionView heightForHeaderInLayout:self];
    }
    
    return 0;
}

@end
