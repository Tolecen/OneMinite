//
//  NCPlayScene.m
//  NCTouch
//
//  Created by liuxiaoyu on 14-2-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NCPlayScene.h"
#import "NCMyScene.h"

@implementation NCPlayScene

- (instancetype)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {
		SKAction *wait = [SKAction waitForDuration:2.f];
		SKAction *action = [SKAction runBlock:^{
			SKTransition *trans = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.2f];
			NCMyScene *playScene = [[NCMyScene alloc] initWithSize:self.size];
			[self.view presentScene:playScene transition:trans];
		}];
		[self runAction:[SKAction sequence:@[wait,action]]];
	}
	return self;
}

@end
