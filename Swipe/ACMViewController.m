//
//  ACMViewController.m
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMViewController.h"

@implementation ACMViewController

@synthesize contentView = _contentView;

- (id)init {
	return [super initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
	[self.view addSubview:backgroundImageView];
	
	[self.view addSubview:self.contentView];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[_contentView removeFromSuperview];
	_contentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Readonly Properties

- (UIView *)contentView {
	if(!_contentView) {
		_contentView = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 11.0, 11.0)];
		_contentView.backgroundColor = [UIColor clearColor];
		_contentView.opaque = NO;
		_contentView.layer.cornerRadius = 4.0;
		_contentView.layer.masksToBounds = YES;
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	
	return _contentView;
}

@end
