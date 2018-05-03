//
//  ItemCollectionViewCell.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 3/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@interface ItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lbText;

@end

@implementation ItemCollectionViewCell

- (void)setText:(NSString *)text {
    _text = text;
    self.lbText.text = text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    self.lbText.text = nil;
}

@end
