//
//  ACMProductCell.h
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import <GMGridView/GMGridView.h>

@interface ACMProductCell : GMGridViewCell

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *detailTextLabel;

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@end
