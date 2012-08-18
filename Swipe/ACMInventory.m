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
	NSMutableArray *_products;
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
		_products = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)loadProducts {
	[[ACMPorygonAPIRequest requestWithRequestType:ACMPorygonAPIRequestTypeInventory] sendWithSuccess:^(NSHTTPURLResponse *response, id responseObject) {
		[self willChangeValueForKey:@"products"];
		
		for(NSDictionary *productDict in (NSArray *)responseObject) {
			ACMProduct *product = [ACMProduct productWithDictionary:productDict];
			
			if(product) {
				[_products addObject:product];
			}
		}
		
		[self didChangeValueForKey:@"products"];
	} failure:^(NSError *error) {
		
	}];
}

- (NSArray *)products {
	return _products;
}

@end
