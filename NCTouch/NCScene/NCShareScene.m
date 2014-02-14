//
//  NCShareScene.m
//  NCTouch
//
//  Created by liuxiaoyu on 14-2-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NCShareScene.h"
#import "NCMyScene.h"

@implementation NCShareScene

- (instancetype)initWithSize:(CGSize)size {
	if (self = [super initWithSize:size]) {
		SKAction *action = [SKAction runBlock:^{
			SKTransition *reveal = [SKTransition flipVerticalWithDuration:.5f];
			NCMyScene *scene = [[NCMyScene alloc] initWithSize:self.size];
			[self.view presentScene:scene transition:reveal];
		}];
		[self runAction:action];
	}
	return self;
}

@end
