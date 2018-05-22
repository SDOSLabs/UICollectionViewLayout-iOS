//
//  HeaderCollectionReusableView.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 15/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *viewSeparator;

@end

@implementation HeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.viewSeparator.backgroundColor = [UIColor orangeColor];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.lbTitle.text = title;
}

@end
