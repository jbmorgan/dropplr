//
//  HelloWorldLayer.h
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/22/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

@property double timeBetweenBallDrops;
@property double timeSinceLastBallDrop;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(double)distanceFrom:(CGPoint)a to:(CGPoint)b;
-(void)popBallsFrom:(b2Body *)b;
@end
