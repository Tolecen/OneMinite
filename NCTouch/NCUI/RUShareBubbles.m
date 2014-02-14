//
//  RUShareBubbles.m
//  RichUI
//
//  Created by liuxiaoyu on 13-12-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RUShareBubbles.h"

@interface RUShareBubbles() {
	UIView *_bgView;
	
	NSMutableArray *_bubbles;
}

@property (nonatomic) BOOL	isAnimating;

@property (nonatomic, copy) void (^completeBlock)(void);

@end

@implementation RUShareBubbles

- (BOOL)isAnimating {
	if (!_isAnimating) {
		_isAnimating = NO;
	}
	return _isAnimating;
}

- (float)bubbleRadius {
	if (!_bubbleRadius) {
		_bubbleRadius = 40.f;
	}
	return _bubbleRadius;
}

- (NSArray *)bubbleColors {
	if (!_bubbleColors) {
		_bubbleColors = [NSArray array];
	}
	return _bubbleColors;
}

- (NSArray *)shareBubbleTypes {
	if (!_shareBubbleTypes) {
		_shareBubbleTypes = [NSArray array];
	}
	return _shareBubbleTypes;
}

- (id)initWithPoint:(CGPoint)centerPoint radius:(CGFloat)radius parentView:(UIView *)parentView {
	self = [super initWithFrame:CGRectMake(centerPoint.x-radius, centerPoint.y-radius, 2*radius, 2*radius)];
	if (self) {
		self.radius = radius;
		self.parentView = parentView;
	}
	return self;
}

- (void)showInParentView {
	if (!self.isAnimating) {
		self.isAnimating = YES;
		[self.parentView addSubview:self];
		
		//Add bgView in order to dismiss shareBubbles
		_bgView = [[UIView alloc] initWithFrame:self.parentView.bounds];
		UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
        [_bgView addGestureRecognizer:tapges];
        [self.parentView insertSubview:_bgView belowSubview:self];
		
		//Add button
		if (_bubbles) {
			_bubbles = nil;
		}
		_bubbles = [NSMutableArray array];
		
		for (int i = 0; i < self.shareBubbleTypes.count; i++) {
			UIButton *bubble = [self shareButtonWithIcon:self.bubbleIcons[i] bubbleColor:self.bubbleColors[i] bubbleType:self.shareBubbleTypes[i]];
			[bubble addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:bubble];
			[_bubbles addObject:bubble];
		}
		
		if (_bubbles.count == 0) {
			return;
		}
	
		float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
		float bubblesBetweenAngle = 360/self.shareBubbleTypes.count;
		
		float angely = (180 - bubblesBetweenAngle) * 0.5;
		float startAngle = 180 - angely;
		
		NSMutableArray *coordinates = [NSMutableArray array];
		for (int i = 0; i < self.shareBubbleTypes.count; ++i) {
			UIButton *bubble = _bubbles[i];
			bubble.tag = i;
			
			float angle = startAngle + i * bubblesBetweenAngle;
            
			float x = cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            float y = sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
						
			[coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", [NSNumber numberWithFloat:y], @"y", nil]];
            
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.center = CGPointMake(self.radius, self.radius);
		}
		
		int inetratorI = 0;
        for (NSDictionary *coordinate in coordinates)
        {
            UIButton *bubble = _bubbles[inetratorI];
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
            ++inetratorI;
        }
	}
}

- (void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    
    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == _bubbles.count - 1) self.isAnimating = NO;
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}

- (void)buttonWasTapped:(UIButton *)sender{
    [self shareButtonTappedWithType:sender.tag];
}

- (void)shareButtonTappedWithType:(ShareBubbleType)buttonType {
	[self hideInParentView];
    if([self.delegate respondsToSelector:@selector(shareBubbles:tappedBubbleWithType:)]) {
        [self.delegate shareBubbles:self tappedBubbleWithType:buttonType];
    }
}

- (UIButton *)shareButtonWithIcon:(NSString *)iconName bubbleColor:(NSString *)rgb bubbleType:(NSString *)type {
	
	UIButton *bubble = [UIButton buttonWithType:UIButtonTypeCustom];
	bubble.frame = CGRectMake(0, 0, 2*self.bubbleRadius, 2*self.bubbleRadius);
	bubble.tag = [type integerValue];
	
	UIView *bubbleBackground = [[UIView alloc] initWithFrame:bubble.frame];
	bubbleBackground.backgroundColor = [self colorFromRGB:[rgb integerValue]];
	bubbleBackground.layer.cornerRadius = self.bubbleRadius;
	bubbleBackground.layer.masksToBounds = YES;
	bubbleBackground.opaque = NO;
	bubbleBackground.alpha = 0.97;
	
	UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    CGRect f = icon.frame;
    f.origin.x = (bubbleBackground.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (bubbleBackground.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    [bubbleBackground addSubview:icon];
	
	[bubble setBackgroundImage:[self imageWithView:bubbleBackground] forState:UIControlStateNormal];
	
	return bubble;
}

- (UIColor *)colorFromRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)shareViewBackgroundTapped:(UITapGestureRecognizer *)tapGesture {
    [tapGesture.view removeFromSuperview];
    [self hideInParentView];
}

- (void)hideInParentView {
	[self hideInParentViewWithCompletionHandle:nil];
}

- (void)hideInParentViewWithCompletionHandle:(void (^)(void))completionHandle {
	self.completeBlock = completionHandle;
	if(!self.isAnimating)
    {
        self.isAnimating = YES;
        int inetratorI = 1;
        for (UIButton *bubble in _bubbles)
        {
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
            ++inetratorI;
        }
    }
}

- (void)hideBubbleWithAnimation:(UIButton *)bubble{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
			[bubble removeFromSuperview];
            if(bubble.tag == _bubbles.count - 1) {
                self.isAnimating = NO;
                self.hidden = YES;
                [_bgView removeFromSuperview];
                _bgView = nil;
                [self removeFromSuperview];
				if (self.completeBlock) {
					self.completeBlock();
				}
            }
        }];
    }];
}


@end
