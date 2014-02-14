//
//  RUShareBubbles.h
//  RichUI
//
//  Created by liuxiaoyu on 13-12-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ShareBubbleType) {
	ShareBubbleTypeSina = 0,
	ShareBubbleTypeTencent = 1,
	ShareBubbleTypeQZone = 2,
	ShareBubbleTypeDouban = 3,
	ShareBubbleTypeRenren = 4,
	ShareBubbleTypeInstagram = 5,
	ShareBubbleTypeFlikr = 6,
	ShareBubbleTypeGooglePlus = 7,
};

@protocol ShareBubblesDelegate;

@interface RUShareBubbles : UIView

@property (nonatomic, strong)	NSArray *shareBubbleTypes;

@property (nonatomic, strong)	NSArray *bubbleColors;

@property (nonatomic, strong)	NSArray *bubbleIcons;

@property (nonatomic, weak)		UIView	*parentView;

@property (nonatomic, assign)	float	bubbleRadius;

@property (nonatomic, assign)	float	radius;

@property (nonatomic, assign)	id <ShareBubblesDelegate>delegate;

- (id)initWithPoint:(CGPoint)centerPoint radius:(CGFloat)radius parentView:(UIView *)parentView;

- (void)showInParentView;

- (void)hideInParentView;

- (void)hideInParentViewWithCompletionHandle:(void(^)(void))completionHandle;

@end

@protocol ShareBubblesDelegate <NSObject>

- (void)shareBubbles:(RUShareBubbles *)shareBubbles tappedBubbleWithType:(ShareBubbleType)bubbleType;

@end
