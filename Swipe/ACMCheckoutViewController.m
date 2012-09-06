//
//  ACMCheckoutViewController.m
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMCheckoutViewController.h"
#import "ACMAlertView.h"
#import "ACMCart.h"
#import "ACMSwiper.h"

@implementation ACMCheckoutViewController {
	UIImageView *_ipadImageView;
	UIImageView *_squareImageView;
	UIImageView *_cardImageView;
	
	ACMSwiper *_swiper;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_ipadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad"]];
	
	CGRect frame = _ipadImageView.frame;
	frame.origin.y = 135.0;
	_ipadImageView.frame = frame;
	
	[self.contentView addSubview:_ipadImageView];
	
	_squareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"square"]];
	
	frame = _squareImageView.frame;
	frame.origin.y = _ipadImageView.frame.origin.y + 27.0;
	frame.origin.x = _ipadImageView.frame.origin.x + _ipadImageView.frame.size.width - 1.0;
	_squareImageView.frame = frame;
	
	[self.contentView addSubview:_squareImageView];
	
	_cardImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card"]];
	_cardImageView.alpha = 0.0;
	_cardImageView.layer.anchorPoint = CGPointZero;
	
	frame = _cardImageView.frame;
	frame.origin.x = _squareImageView.frame.origin.x + 28.0;
	frame.origin.y = - frame.size.height + _squareImageView.frame.origin.y - 20.0;
	_cardImageView.frame = frame;
	
	[self.contentView insertSubview:_cardImageView belowSubview:_squareImageView];
	
	UILabel *swipeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	swipeLabel.text = NSLocalizedString(@"Swipe your NJIT ID", @"Swipe your NJIT ID");
	swipeLabel.font = [UIFont boldSystemFontOfSize:30.0];
	swipeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	swipeLabel.backgroundColor = [UIColor clearColor];
	swipeLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
	[swipeLabel sizeToFit];
	
	frame = swipeLabel.frame;
	frame.origin.x = self.contentView.frame.size.width - frame.size.width - 60.0;
	frame.origin.y = 120.0;
	swipeLabel.frame = frame;
	
	[self.contentView addSubview:swipeLabel];
	
	// TODO: Style this button.
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:NSLocalizedString(@"Modify Order", @"Modify Order") forState:UIControlStateNormal];
	[button addTarget:self action:@selector(modifyOrder:) forControlEvents:UIControlEventTouchUpInside];
	button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[button sizeToFit];
	
	frame = button.frame;
	frame.origin.x = swipeLabel.frame.origin.x;
	frame.origin.y = swipeLabel.frame.origin.y + swipeLabel.frame.size.height + 10.0;
	frame.size.width = swipeLabel.frame.size.width;
	button.frame = frame;
	
	[self.contentView addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self _startAnimation];
	
	_swiper = [[ACMSwiper alloc] init];
	[_swiper start];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self _stopAnimation];
	
	[_swiper stop];
}

#pragma mark - Actions

- (void)modifyOrder:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cancelOrder:(id)sender {
	ACMAlertView *alertView = [[ACMAlertView alloc] initWithTitle:NSLocalizedString(@"Cancel Order?", @"Cancel Order?") message:NSLocalizedString(@"Are you sure you want to cancel your order? This will clear your cart and cannot be undone.", @"Are you sure you want to cancel your order? This will clear your cart and cannot be undone.")];
	alertView.cancelButtonIndex = [alertView addButtonWithTitle:@"Never Mind"];
	[alertView addButtonWithTitle:@"Cancel Order" block:^{
		[[ACMCart cart] resetCart];
		
		[self dismissViewControllerAnimated:YES completion:NULL];
	}];
	[alertView show];
}

#pragma mark - Animation

- (void)_startAnimation {
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
	fadeInAnimation.duration = 0.5;
	fadeInAnimation.beginTime = 0.0;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	
	CGPoint position = _cardImageView.layer.position;
	
	CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	translateAnimation.fromValue = [NSValue valueWithCGPoint:position];
	translateAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(position.x, _squareImageView.layer.position.y + _squareImageView.layer.bounds.size.height + 50)];
	translateAnimation.duration = 0.75;
	translateAnimation.beginTime = 0.75;
	translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	translateAnimation.removedOnCompletion = NO;
	translateAnimation.fillMode = kCAFillModeForwards;
	
	CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
	fadeOutAnimation.duration = 0.5;
	fadeOutAnimation.beginTime = 2.0;
	fadeOutAnimation.removedOnCompletion = NO;
	fadeOutAnimation.fillMode = kCAFillModeForwards;
	
	CABasicAnimation *resetAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	resetAnimation.fromValue = translateAnimation.toValue;
	resetAnimation.toValue = [NSValue valueWithCGPoint:position];
	resetAnimation.duration = 0.1;
	resetAnimation.beginTime = 3.9;
	resetAnimation.removedOnCompletion = NO;
	resetAnimation.fillMode = kCAFillModeForwards;
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	[group setDuration:4.0];
	[group setAnimations:@[fadeInAnimation, translateAnimation, fadeOutAnimation]];
	group.delegate = self;	
	
	[_cardImageView.layer addAnimation:group forKey:@"swipeAnimation"];
}

- (void)_stopAnimation {
	[_cardImageView.layer removeAnimationForKey:@"swipeAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	// TODO: add some sort of flag to stop the animation.
	
	[_cardImageView.layer removeAnimationForKey:@"swipeAnimation"];
	
	[self _startAnimation];
}

@end
