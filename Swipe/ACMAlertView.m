//
//  ACMAlertView.m
//  Swipe
//
//  Created by Grant Butler on 8/23/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMAlertView.h"

@implementation ACMAlertView {
	NSMutableDictionary *_blocks;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
	if((self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil])) {
		_blocks = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(dispatch_block_t)block {
	NSInteger index = [self addButtonWithTitle:title];
	
	[_blocks setObject:[block copy] forKey:[NSNumber numberWithInteger:index]];
	
	return index;
}

- (NSInteger)addCancelButtonWithTitle:(NSString *)title block:(dispatch_block_t)block {
	self.cancelButtonIndex = [self addButtonWithTitle:title block:block];
	
	return self.cancelButtonIndex;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	dispatch_block_t block = [_blocks objectForKey:[NSNumber numberWithInteger:buttonIndex]];
	
	if(block) {
		block();
	}
}

- (void)dealloc {
	self.delegate = nil;
	
	_blocks = nil;
}

@end
