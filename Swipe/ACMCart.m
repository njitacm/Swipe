//
//  ACMCart.m
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMCart.h"

@implementation ACMCart {
	NSMutableArray *_items;
	
	NSNumber *_total;
}

+ (ACMCart *)cart {
	static ACMCart *cart = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cart = [[ACMCart alloc] init];
	});
	
	return cart;
}

- (id)init {
	if((self = [super init])) {
		[self reset];
	}
	
	return self;
}

- (void)reset {
	_items = [[NSMutableArray alloc] init];
}

- (void)addCartItem:(ACMCartItem *)item {
	ACMCartItem *foundItem = [self cartItemWithProduct:item.product];
	
	if(foundItem) {
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[_items indexOfObject:foundItem]];
		
		foundItem.count = item.count;
		
		[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:@"items"];
		[_items replaceObjectAtIndex:indexSet.firstIndex withObject:foundItem];
		[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:@"items"];
	} else {
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[_items count]];
		
		[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"items"];
		[_items addObject:item];
		[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"items"];
	}
	
	[self willChangeValueForKey:@"total"];
	_total = nil;
	[self didChangeValueForKey:@"total"];
}

- (ACMCartItem *)cartItemWithProduct:(ACMProduct *)product {
	__block ACMCartItem *item = nil;
	
	[_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if(![obj isKindOfClass:[ACMCartItem class]]) {
			return;
		}
		
		ACMCartItem *cartItem = (ACMCartItem *)obj;
		
		if([[cartItem.product objectID] isEqual:[product objectID]]) {
			item = cartItem;
			
			*stop = YES;
		}
	}];
	
	return item;
}

- (void)removeCartItemWithProduct:(ACMProduct *)product {
	ACMCartItem *item = [self cartItemWithProduct:product];
	
	NSInteger index = [_items indexOfObject:item];
	
	if(index == NSNotFound) {
		return;
	}
	
	[self removeCartItemAtIndex:index];
}

- (void)removeCartItemAtIndex:(NSUInteger)index {
	if(index >= [_items count]) {
		return;
	}
	
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"items"];
	[_items removeObjectAtIndex:index];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:[NSIndexSet indexSetWithIndex:index] forKey:@"items"];
	
	[self willChangeValueForKey:@"total"];
	_total = nil;
	[self didChangeValueForKey:@"total"];
}

- (NSArray *)items {
	return _items;
}

- (NSNumber *)total {
	if(!_total) {
		__block CGFloat total = 0.0;
		
		[_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if(![obj isKindOfClass:[ACMCartItem class]]) {
				return;
			}
			
			ACMCartItem *item = (ACMCartItem *)obj;
			
			total += [item.product.price intValue] * item.count;
		}];
		
		_total = [NSNumber numberWithFloat:total];
	}
	
	return _total;
}

@end
