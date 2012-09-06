//
//  ACMSwipeDecoder.m
//  Swipe
//
//  Created by Grant Butler on 9/4/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMSwipeDecoder.h"

@implementation ACMSwipeDecoder {
	NSData *_data;
}

- (id)initWithData:(NSData *)data {
	if((self = [super init])) {
		_data = data;
	}
	
	return self;
}

- (void)decode {
	
}


@end
