//
//  ACMInventory.m
//  Swipe
//
//  Created by Grant Butler on 8/16/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMInventory.h"
#import "ACMPorygonAPIRequest.h"

@implementation ACMInventory {
	NSMutableDictionary *_products;
}

+ (ACMInventory *)sharedInventory {
	static ACMInventory *sharedInventory = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInventory = [[ACMInventory alloc] init];
	});
	
	return sharedInventory;
}

- (id)init {
	if((self = [super init])) {
		_products = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)loadProducts {
	[[ACMPorygonAPIRequest requestWithRequestType:ACMPorygonAPIRequestTypeInventory] sendWithSuccess:^(NSHTTPURLResponse *response, id responseObject) {
		for(NSDictionary *productDict in (NSArray *)responseObject) {
			ACMProduct *product = [ACMProduct productWithDictionary:productDict];
			
			if(product) {
				[_products setObject:product forKey:product.objectID];
			}
		}
	} failure:^(NSError *error) {
		
	}];
}

- (ACMProduct *)productWithObjectID:(NSInteger)objectID {
	return [_products objectForKey:[NSNumber numberWithInteger:objectID]];
}

@end
