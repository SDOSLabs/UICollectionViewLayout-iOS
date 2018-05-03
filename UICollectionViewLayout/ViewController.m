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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCells];
    
    self.collectionView.collectionViewLayout = [GridCollectionViewLayout new];
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCells {
    UINib *itemNib = [UINib nibWithNibName:NSStringFromClass([ItemCollectionViewCell class]) bundle:nil];
    [self.collectionView registerNib:itemNib forCellWithReuseIdentifier:NSStringFromClass([ItemCollectionViewCell class])];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 50;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ItemCollectionViewCell class]) forIndexPath:indexPath];
    itemCell.text = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    return itemCell;
}

@end
