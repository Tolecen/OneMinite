//
//  NCMyScene.m
//  NCTouch
//
//  Created by liuxiaoyu on 14-2-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NCMyScene.h"
#import "NCPlayScene.h"
#import "NCShareScene.h"

static NSString *const CategoryNameOfStartScene = @"CategoryNameOfStartScene";

@interface NCMyScene()

@property (nonatomic) BOOL contentCreated;

@property (nonatomic) BOOL isFingerOnLabel;

@property (nonatomic, weak) SKLabelNode *currentNode;

@end

@implementation NCMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
		
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
	if (!self.contentCreated) {
		self.backgroundColor = [UIColor whiteColor];
		self.scaleMode = SKSceneScaleModeAspectFill;
		self.physicsWorld.gravity = CGVectorMake(0, 0);
		
		SKLabelNode *gameName = [self createLabelWithFontName:@"Chalkduster"
														 text:@"急速一分钟"
													fontColor:[UIColor blueColor]
													 fontSize:30
													 position:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)];
		[self addChild:gameName];
	
		SKLabelNode *gameStart = [self createLabelWithFontName:@"Chalkduster"
														  text:@"开始游戏"
													 fontColor:[UIColor blueColor]
													  fontSize:24
													  position:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(gameName.frame)-150)];
		gameStart.name = CategoryNameOfStartScene;
		gameStart.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gameStart.frame.size];
		[self addChild:gameStart];
		
		SKLabelNode *gameTutorial = [self createLabelWithFontName:@"Chalkduster"
															 text:@"教程指导"
														fontColor:[UIColor blueColor]
														 fontSize:24
														 position:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(gameStart.frame)-100)];
		gameTutorial.name = CategoryNameOfStartScene;
		gameTutorial.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gameTutorial.frame.size];
		[self addChild:gameTutorial];
		
		SKLabelNode *gameShare = [self createLabelWithFontName:@"Chalkduster"
														  text:@"分享"
													 fontColor:[UIColor blueColor]
													  fontSize:24
													  position:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(gameTutorial.frame)-100)];
		gameShare.name = CategoryNameOfStartScene;
		gameShare.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:gameShare.frame.size];
		[self addChild:gameShare];
		
		self.contentCreated = YES;
	}
}

- (SKLabelNode *)createLabelWithFontName:(NSString *)fontName text:(NSString *)text fontColor:(UIColor *)fontColor fontSize:(CGFloat)fontSize position:(CGPoint)position {
	SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
	label.text = NSLocalizedString(text, @"");
	label.fontColor = (SKColor *)fontColor;
	label.fontSize = fontSize;
	label.position = position;
	return label;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.currentNode = nil;
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInNode:self];
		
	SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:touchLocation];
	if (body && [body.node.name isEqualToString:CategoryNameOfStartScene]) {
		self.currentNode = (SKLabelNode *)body.node;
        SKAction *zoom = [SKAction scaleTo:1.2 duration:0.25];
		[self.currentNode runAction:zoom];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInNode:self];
	SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:touchLocation];
	SKAction *zoom = [SKAction scaleTo:1 duration:0.25];

	if (body && [body.node.name isEqualToString:CategoryNameOfStartScene]) {
		if ([self.currentNode.text isEqualToString:NSLocalizedString(@"开始游戏", @"")]) {
			SKAction *action = [SKAction runBlock:^{
				SKTransition *trans = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.2f];
				NCPlayScene *playScene = [[NCPlayScene alloc] initWithSize:self.size];
				[self.view presentScene:playScene transition:trans];
			}];
			[self runAction:action];
		} else if ([self.currentNode.text isEqualToString:NSLocalizedString(@"教程指导", @"")]) {
			[self.currentNode runAction:zoom];
		} else if ([self.currentNode.text isEqualToString:NSLocalizedString(@"分享", @"")]) {
			SKAction *action = [SKAction runBlock:^{
				SKTransition *trans = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:.2f];
				NCShareScene *playScene = [[NCShareScene alloc] initWithSize:self.size];
				[self.view presentScene:playScene transition:trans];
			}];
			[self runAction:action];
		} else {
			
		}
	} else {
		[self.currentNode runAction:zoom];
	}
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)dealloc {
	self.currentNode = nil;
}

@end
