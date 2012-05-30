//
//  Ball.m
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
#define BALL_SCALE 0.6

@implementation Ball
@synthesize sprite, type;

-(id)init {
	if(self = [super init]) {
		
		//NSArray *spriteIDs = [[NSArray alloc] initWithObjects:@"c.png", @"y.png", @"m.png", @"dg.png", @"lg.png", nil];
		NSArray *spriteIDs = [[NSArray alloc] initWithObjects:@"c.png", @"y.png", @"m.png", nil];
		type = (BallType)(arc4random() % spriteIDs.count);
		NSString *spriteID = [spriteIDs objectAtIndex:(int)type];

		if(CCRANDOM_0_1() < 0.02) {
			spriteID = @"pause.png";
			type = kPause;
		} else 		if(CCRANDOM_0_1() < 0.02) {
			spriteID = @"ff.png";
			type = kFastForward;
		}
		sprite = [CCSprite spriteWithSpriteFrameName:spriteID];
		sprite.scale = BALL_SCALE;
		[self addChild:sprite];
	}
	return self;
}

-(double)distanceTo:(Ball *)b {
	return sqrt( (self.position.x-b.position.x)*(self.position.x-b.position.x) +
				(self.position.y-b.position.y)*(self.position.y-b.position.y) );
}
@end
