//
//  GameOverLayer.m
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "ScoreKeeper.h"

@implementation GameOverLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverLayer *layer = [GameOverLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
				
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		//[self addChild:[[ScoreKeeper sharedScoreKeeper] scoreLabel]];
		CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"gameover.png"];
		backgroundSprite.position = ccp(screenSize.width * 0.5, screenSize.height * 0.5);
		[self addChild:backgroundSprite];
	}
	return self;
}
@end
