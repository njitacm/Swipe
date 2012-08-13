//
//  ACMRootViewController.m
//  Swipe
//
//  Created by Grant Butler on 8/12/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMRootViewController.h"

@interface ACMRootViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ACMRootViewController {
	UINavigationBar *_cartNavigationBar;
	UITableView *_cartTableView;
	
	UIBarButtonItem *_editBarButtonItem;
	UIBarButtonItem *_doneBarButtonItem;
}

@synthesize contentView = _contentView;

- (id)init {
	if((self = [super initWithNibName:nil bundle:nil])) {
		self.title = NSLocalizedString(@"Cart", @"Cart");
		
		_editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_toggleEditing:)];
		_doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_toggleEditing:)];
		
		self.navigationItem.rightBarButtonItem = _editBarButtonItem;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
	[self.view addSubview:backgroundImageView];
	
	[self.view addSubview:self.contentView];
	
	_cartNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
	_cartNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
	[_cartNavigationBar pushNavigationItem:self.navigationItem animated:NO];
	[_cartNavigationBar sizeToFit];
	
	CGRect navBarBounds = _cartNavigationBar.frame;
	navBarBounds.size.width = 300.0;
	navBarBounds.origin.x = self.contentView.frame.size.width - navBarBounds.size.width;
	_cartNavigationBar.frame = navBarBounds;
	
	[self.contentView addSubview:_cartNavigationBar];
	
	_cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(navBarBounds.origin.x, navBarBounds.size.height + 1, navBarBounds.size.width, self.contentView.frame.size.height - (navBarBounds.size.height * 2))];
	_cartTableView.backgroundColor = [UIColor clearColor];
	_cartTableView.separatorColor = [UIColor colorWithWhite:0.75 alpha:1.0];
	_cartTableView.delegate = self;
	_cartTableView.dataSource = self;
	_cartTableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	
	[self.contentView addSubview:_cartTableView];
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Actions

- (void)_toggleEditing:(id)sender {
	if(_cartTableView.editing) {
		[_cartTableView setEditing:NO animated:YES];
		
		[self.navigationItem setRightBarButtonItem:_editBarButtonItem animated:YES];
	} else {
		[_cartTableView setEditing:YES animated:YES];
		
		[self.navigationItem setRightBarButtonItem:_doneBarButtonItem animated:YES];
	}
}

#pragma mark -

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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
	
	return cell;
}

@end
