//
//  ACMRootViewController.m
//  Swipe
//
//  Created by Grant Butler on 8/12/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMRootViewController.h"
#import "ACMPorygonAPIRequest.h"
#import "ACMButton.h"
#import "ACMInventory.h"
#import "ACMCart.h"

#import <GMGridView/GMGridView.h>
#import <GMGridView/GMGridViewLayoutStrategies.h>

@interface ACMRootViewController () <UITableViewDataSource, UITableViewDelegate, GMGridViewDataSource, GMGridViewActionDelegate>

@end

@implementation ACMRootViewController {
	UINavigationBar *_cartNavigationBar;
	UITableView *_cartTableView;
	ACMButton *_cartCheckoutButton;
	
	GMGridView *_gridView;
	
	UIBarButtonItem *_editBarButtonItem;
	UIBarButtonItem *_doneBarButtonItem;
	
	NSNumberFormatter *_currencyFormatter;
}

@synthesize contentView = _contentView;

- (id)init {
	if((self = [super initWithNibName:nil bundle:nil])) {
		self.title = NSLocalizedString(@"Cart", @"Cart");
		
		_editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_toggleEditing:)];
		_doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_toggleEditing:)];
		
		self.navigationItem.rightBarButtonItem = _editBarButtonItem;
		
		_currencyFormatter = [[NSNumberFormatter alloc] init];
		_currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
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
	
	_cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(navBarBounds.origin.x, navBarBounds.size.height, navBarBounds.size.width, self.contentView.frame.size.height - (navBarBounds.size.height * 2.0))];
	_cartTableView.backgroundColor = [UIColor clearColor];
	_cartTableView.separatorColor = [UIColor colorWithWhite:0.75 alpha:1.0];
	_cartTableView.delegate = self;
	_cartTableView.dataSource = self;
	_cartTableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	
	[self.contentView addSubview:_cartTableView];
	
	_cartCheckoutButton = [ACMButton buttonWithType:UIButtonTypeCustom];
	[_cartCheckoutButton setTitle:NSLocalizedString(@"Check Out", @"Check Out") forState:UIControlStateNormal];
	[_cartCheckoutButton addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
	[_cartCheckoutButton sizeToFit];
	_cartCheckoutButton.frame = CGRectMake(navBarBounds.origin.x, _cartTableView.frame.origin.y + _cartTableView.bounds.size.height, navBarBounds.size.width, navBarBounds.size.height + 1.0);
	_cartCheckoutButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
	
	[self.contentView addSubview:_cartCheckoutButton];
	
	UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(navBarBounds.origin.x - 1, 0.0, 1.0, self.contentView.frame.size.height)];
	divider.backgroundColor = _cartTableView.separatorColor;
	divider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[self.contentView addSubview:divider];
	
	_gridView = [[GMGridView alloc] initWithFrame:CGRectMake(0.0, 0.0, divider.frame.origin.x, self.contentView.frame.size.height)];
	_gridView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	_gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
	_gridView.dataSource = self;
	_gridView.actionDelegate = self;
	[self.contentView addSubview:_gridView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[_cartNavigationBar removeFromSuperview];
	_cartNavigationBar = nil;
	
	[_cartTableView removeFromSuperview];
	_cartTableView = nil;
	
	[_cartCheckoutButton removeFromSuperview];
	_cartCheckoutButton = nil;
	
	[_contentView removeFromSuperview];
	_contentView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[_cartTableView reloadData];
	[_gridView reloadData];
	
	[[ACMInventory sharedInventory] addObserver:self forKeyPath:@"products" options:0 context:NULL];
	[[ACMCart cart] addObserver:self forKeyPath:@"items" options:0 context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[ACMInventory sharedInventory] removeObserver:self forKeyPath:@"products"];
	[[ACMCart cart] removeObserver:self forKeyPath:@"items"];
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

- (void)checkout:(id)sender {
	
}

#pragma mark - 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if(object == [ACMInventory sharedInventory] && [keyPath isEqualToString:@"products"]) {
		// TODO: Check the value of change, and only reload those cells.
		
		[_gridView reloadData];
	} else if(object == [ACMCart cart] && [keyPath isEqualToString:@"items"]) {
		NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
		
		if([kind intValue] == NSKeyValueChangeInsertion) {
			NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
			
			[_cartTableView beginUpdates];
			
			NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
			
			[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
			}];
			
			[_cartTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
			
			[_cartTableView endUpdates];
		} else if([kind intValue] == NSKeyValueChangeReplacement) {
			NSIndexSet *indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
			
			[_cartTableView beginUpdates];
			
			NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
			
			[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
			}];
			
			[_cartTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
			
			[_cartTableView endUpdates];
		}
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
	return [[[ACMCart cart] items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
	}
	
	ACMCartItem *item = [[[ACMCart cart] items] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = item.product.name;
	cell.detailTextLabel.text = [_currencyFormatter stringFromNumber:[NSNumber numberWithFloat:item.count * [item.product.price floatValue]]];
	
	return cell;
}

#pragma mark - GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
	return [[[ACMInventory sharedInventory] products] count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return CGSizeMake(160, 200);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
	GMGridViewCell *cell = [gridView dequeueReusableCell];
	
	CGSize cellSize = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	
	if(!cell) {
		cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, cellSize.width, cellSize.height)];
		
		UIView *contentView = [[UIView alloc] initWithFrame:cell.bounds];
		cell.contentView = contentView;
	}
	
	[[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	ACMProduct *product = [[[ACMInventory sharedInventory] products] objectAtIndex:index];
	
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.width)];
	[cell.contentView addSubview:container];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.textAlignment = UITextAlignmentCenter;
	[label setText:product.name];
	[label sizeToFit];
	
	CGRect frame = label.frame;
	frame.origin.y = container.frame.size.height;
	frame.size.width = cell.contentView.frame.size.width;
	label.frame = frame;
	
	[cell.contentView addSubview:label];
	
	return cell;
}

#pragma mark - GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
	// Add one to the cart.
	
	ACMProduct *product = [[[ACMInventory sharedInventory] products] objectAtIndex:position];
	
	ACMCartItem *item = [[ACMCart cart] cartItemWithProduct:product];
	
	if(!item) {
		item = [[ACMCartItem alloc] init];
		item.product = product;
	}
	
	item.count++;
	
	[[ACMCart cart] addCartItem:item];
}

@end
