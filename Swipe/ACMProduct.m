//
//  ACMProduct.m
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMProduct.h"

@implementation ACMProduct

+ (ACMProduct *)productWithDictionary:(NSDictionary *)dict {
	if(![dict objectForKey:@"iid"]) {
		return nil;
	}
	
	ACMProduct *product = [[ACMProduct alloc] init];
	product.objectID = [dict objectForKey:@"iid"];
	product.name = [dict objectForKey:@"name"];
	product.text = [dict objectForKey:@"description"];
	product.price = [dict objectForKey:@"price"];
	product.stock = [dict objectForKey:@"stock"];
	product.pictureURL = [NSURL URLWithString:[dict objectForKey:@"picture"]];
	
	// TODO: Load image, either from a cache, or from the web.
	
	return product;
}

@end
