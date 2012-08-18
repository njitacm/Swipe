//
//  ACMCheckoutViewController.m
//  Swipe
//
//  Created by Grant Butler on 8/18/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMCheckoutViewController.h"

@implementation ACMCheckoutViewController {
	UIImageView *_ipadImageView;
	UIImageView *_squareImageView;
	UIImageView *_cardImageView;
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
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self _startAnimation];
}

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
	translateAnimation.duration = 1.0;
	translateAnimation.beginTime = 0.75;
	translateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	translateAnimation.removedOnCompletion = NO;
	translateAnimation.fillMode = kCAFillModeForwards;
	
	CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0];
	fadeOutAnimation.duration = 0.5;
	fadeOutAnimation.beginTime = 2.25;
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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	[_cardImageView.layer removeAnimationForKey:@"swipeAnimation"];
	
	[self _startAnimation];
}

@end
