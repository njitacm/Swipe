//
//  ACMButton.m
//  Swipe
//
//  Created by Grant Butler on 8/17/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMButton.h"

#import <SSToolkit/SSDrawingUtilities.h>

@implementation ACMButton {
	CGGradientRef _gradientRef;
	CGGradientRef _highlightedGradientRef;
}

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
		NSDictionary *titleTextAttributes = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal];
		NSDictionary *highlightedTitleTextAttributes = [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateHighlighted];
		
		[self setTitleColor:[titleTextAttributes objectForKey:UITextAttributeTextColor] forState:UIControlStateNormal];
		[self setTitleColor:[highlightedTitleTextAttributes objectForKey:UITextAttributeTextColor] forState:UIControlStateHighlighted];
		
		[self setTitleShadowColor:[titleTextAttributes objectForKey:UITextAttributeTextShadowColor] forState:UIControlStateNormal];
		[self setTitleShadowColor:[highlightedTitleTextAttributes objectForKey:UITextAttributeTextShadowColor] forState:UIControlStateHighlighted];
		
		[[self titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
		[[self titleLabel] setShadowOffset:[[titleTextAttributes objectForKey:UITextAttributeTextShadowOffset] CGSizeValue]];
		
		_gradientRef = SSCreateGradientWithColors(@[
												  [UIColor colorWithWhite:0.85 alpha:1.0],
												  [UIColor colorWithWhite:0.75 alpha:1.0]
												  ]);
		
		_highlightedGradientRef = SSCreateGradientWithColors(@[
															 [UIColor colorWithWhite:0.75 alpha:1.0],
															 [UIColor colorWithWhite:0.65 alpha:1.0]
															 ]);
		
		[self addObserver:self forKeyPath:@"highlighted" options:0 context:NULL];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGPoint startPoint = CGPointZero;
	CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);
	
	if(self.highlighted) {
		CGContextDrawLinearGradient(ctx, _highlightedGradientRef, startPoint, endPoint, 0);
	} else {
		CGContextDrawLinearGradient(ctx, _gradientRef, startPoint, endPoint, 0);
	}
	
	UIColor *topBorder = [UIColor colorWithWhite:0.75 alpha:1.0];
	
	if(self.highlighted) {
		topBorder = [UIColor colorWithWhite:0.65 alpha:1.0];
	}
	
	CGContextSaveGState(ctx);
	
	[topBorder set];
	
	CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, 1.0), 0.0, [UIColor colorWithWhite:1.0 alpha:0.25].CGColor);
	
	CGContextFillRect(ctx, CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0));
	
	CGContextRestoreGState(ctx);
	
	UIColor *bottomBorder = [UIColor colorWithWhite:0.65 alpha:1.0];
	
	if(self.highlighted) {
		bottomBorder = [UIColor colorWithWhite:0.55 alpha:1.0];
	}
	
	[bottomBorder set];
	
	CGContextFillRect(ctx, CGRectMake(0.0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"highlighted"]) {
		[self setNeedsDisplay];
	}
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"highlighted"];
	
	CGGradientRelease(_gradientRef);
	CGGradientRelease(_highlightedGradientRef);
}

@end
