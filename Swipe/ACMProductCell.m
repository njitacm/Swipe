//
//  ACMProductCell.m
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMProductCell.h"

@implementation ACMProductCell {
	UILabel *_titleLabel;
	UILabel *_detailTextLabel;
	
	UIImageView *_imageView;
	
	UIView *_container;
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
		self.contentView = contentView;
		
		_container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.width)];
		[self.contentView addSubview:_container];
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_titleLabel sizeToFit];
	[_detailTextLabel sizeToFit];
	[_imageView sizeToFit];
	
	_imageView.center = CGPointMake(roundf(_container.frame.size.width / 2.0), roundf(_container.frame.size.height / 2.0));
	
	CGRect frame = _titleLabel.frame;
	frame.origin.y = _container.frame.size.height;
	frame.size.width = self.contentView.frame.size.width;
	_titleLabel.frame = frame;
	
	frame = _detailTextLabel.frame;
	frame.origin.y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
	frame.size.width = self.contentView.frame.size.width;
	_detailTextLabel.frame = frame;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	[_titleLabel removeFromSuperview];
	_titleLabel = nil;
	
	[_detailTextLabel removeFromSuperview];
	_detailTextLabel = nil;
	
	[_imageView removeFromSuperview];
	_imageView = nil;
}

#pragma mark - Readonly Properties

- (UILabel *)titleLabel {
	if(!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.textAlignment = UITextAlignmentCenter;
		_titleLabel.backgroundColor = [UIColor clearColor];
		
		[self.contentView addSubview:_titleLabel];
	}
	
	return _titleLabel;
}

- (UILabel *)detailTextLabel {
	if(!_detailTextLabel) {
		_detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_detailTextLabel.textAlignment = UITextAlignmentCenter;
		_detailTextLabel.backgroundColor = [UIColor clearColor];
		_detailTextLabel.textColor = [UIColor darkGrayColor];
		_detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		
		[self.contentView addSubview:_detailTextLabel];
	}
	
	return _detailTextLabel;
}

- (UIImageView *)imageView {
	if(!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		
		[_container addSubview:_imageView];
	}
	
	return _imageView;
}

@end
