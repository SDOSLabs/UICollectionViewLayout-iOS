//
//  ViewController.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 26/4/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "ViewController.h"
#import "GridCollectionViewLayout.h"
#import "ItemCollectionViewCell.h"
#import "ShadowCollectionReusableView.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.collectionViewLayout = [GridCollectionViewLayout new];
    [self registerCells];
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCells {
    UINib *itemNib = [UINib nibWithNibName:NSStringFromClass([ItemCollectionViewCell class]) bundle:nil];
    [self.collectionView registerNib:itemNib forCellWithReuseIdentifier:NSStringFromClass([ItemCollectionViewCell class])];
    
    UINib *shadowNib = [UINib nibWithNibName:NSStringFromClass([ShadowCollectionReusableView class]) bundle:nil];
    [self.collectionView.collectionViewLayout registerNib:shadowNib forDecorationViewOfKind:CollectionElementKindGridVerticalShadow];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 50;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ItemCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        itemCell.text = [NSString stringWithFormat:@"Fila %ld", (long)indexPath.row + 1];
    } else {
        itemCell.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.row + 1, (long)indexPath.section];
    }
    return itemCell;
}

@end
