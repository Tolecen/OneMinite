//
//  NCShareScene.m
//  NCTouch
//
//  Created by liuxiaoyu on 14-2-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NCShareScene.h"
#import "NCMyScene.h"
#import "RUShareBubbles.h"

@interface NCShareScene()<ShareBubblesDelegate>

@property (nonatomic) BOOL contentCreated;

@property (nonatomic, strong) RUShareBubbles *shareBubbles;

@end

@implementation NCShareScene

- (instancetype)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {

	}
	return self;
}

- (void)didMoveToView:(SKView *)view {
	if (!self.contentCreated) {
		
		RUShareBubbles *shareBubbles = [[RUShareBubbles alloc] initWithPoint:view.center radius:100 parentView:self.view];
		shareBubbles.delegate = self;
		shareBubbles.shareBubbleTypes = @[@(ShareBubbleTypeSina),@(ShareBubbleTypeTencent),@(ShareBubbleTypeRenren),@(ShareBubbleTypeQZone)];
		shareBubbles.bubbleColors = @[@(0xFFFF00),@(0xFFFF00),@(0xFFFF00),@(0xFFFF00)];
		shareBubbles.bubbleIcons = @[@"icon-aa-twitter@2x",@"icon-aa-twitter@2x",@"icon-aa-twitter@2x",@"icon-aa-twitter@2x"];
		self.shareBubbles = shareBubbles;
		[shareBubbles showInParentView];
		
		self.contentCreated = YES;
	}
}

- (void)shareBubbles:(RUShareBubbles *)shareBubbles tappedBubbleWithType:(ShareBubbleType)bubbleType {
	[self.shareBubbles hideInParentViewWithCompletionHandle:^{
		SKAction *action = [SKAction runBlock:^{
			SKTransition *trans = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.2f];
			NCMyScene *playScene = [[NCMyScene alloc] initWithSize:self.size];
			[self.view presentScene:playScene transition:trans];
		}];
		[self runAction:action];
	}];
}

- (void)dealloc {
	self.shareBubbles = nil;
}

@end
