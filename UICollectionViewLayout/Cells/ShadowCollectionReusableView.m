//
//  ShadowCollectionReusableView.m
//  UICollectionViewLayout
//
//  Created by Gabriel Oria de Rueda on 15/5/18.
//  Copyright © 2018 Sdos. All rights reserved.
//

#import "ShadowCollectionReusableView.h"

@interface ShadowCollectionReusableView()

@property (weak, nonatomic) IBOutlet UIView *viewShadow;

@end

@implementation ShadowCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.viewShadow.layer.masksToBounds = NO;
    self.viewShadow.layer.shadowOffset = CGSizeMake(3, 0);
    self.viewShadow.layer.shadowOpacity = 0.44f;
    self.viewShadow.layer.shadowRadius = 2;
    self.viewShadow.layer.shadowColor = [UIColor blackColor].CGColor;
}

@end
