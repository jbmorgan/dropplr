//
//  Ball.h
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum BallType {
	Cyan = 0,
	Yellow,
	Magenta
} BallType;

@interface Ball : CCNode

-(double)distanceTo:(Ball *)b;

@property (nonatomic, retain) CCSprite *sprite;
@property BallType type;
@end