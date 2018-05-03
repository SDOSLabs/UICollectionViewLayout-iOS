//
//  GridCollectionViewLayout.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 3/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "GridCollectionViewLayout.h"

#define ITEM_SIZE 50

@interface GridCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *itemAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation GridCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemAttributes = [NSMutableArray array];
    
    CGFloat xOffset = self.collectionView.contentInset.left;
    CGFloat yOffset = self.collectionView.contentInset.top;
    
    NSUInteger numberOfColumns = [self.collectionView numberOfSections];
    NSUInteger numberOfRows = [self.collectionView numberOfItemsInSection:0];
    for (int row = 0; row < numberOfRows; row++) {
        
        NSMutableArray *sectionAttributes = [NSMutableArray array];
        for (NSUInteger column = 0; column < numberOfColumns; column++) {
            // Creamos UICollectionViewLayoutAttributes para cada elemento y los añadimos al array de atributos. Lo utilizaremos después
            // para layoutAttributesForElementsInRect:
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:column];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, ITEM_SIZE, ITEM_SIZE));
            [sectionAttributes addObject:attributes];
            
            xOffset = xOffset + ITEM_SIZE;
        }
        
        xOffset = 0;
        yOffset = yOffset + ITEM_SIZE;
        [self.itemAttributes addObject:sectionAttributes];
    }
    
    // Calculamos el contentSize a partir de los atributos del último elemento
    UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
    CGFloat contentWidth = attributes.frame.origin.x + attributes.frame.size.width;
    CGFloat contentHeight = attributes.frame.origin.y + attributes.frame.size.height;
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    
    return attributes;
}

@end
