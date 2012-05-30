//
//  DropplrGameplayLayer.mm
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/22/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "DropplrGameplayLayer.h"
#import "ScoreKeeper.h"
#import "Ball.h"
#import "GameOverLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define BALL_SCALE 0.6

#define DEFAULT_PAUSE_TIME 5.0

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation DropplrGameplayLayer

@synthesize timeBetweenBallDrops, timeSinceLastBallDrop, timeLeftBeforeUnpause, state;

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DropplrGameplayLayer *layer = [DropplrGameplayLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		//self.isAccelerometerEnabled = YES;
		
		state = kNormal;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
		//		flags += b2DebugDraw::e_jointBit;
		//		flags += b2DebugDraw::e_aabbBit;
		//		flags += b2DebugDraw::e_pairBit;
		//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,(screenSize.height+100)/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,(screenSize.height+100)/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,(screenSize.height+100)/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,(screenSize.height+100)/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		//Set up sprite
		/*
		 CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		 [self addChild:batch z:0 tag:kTagBatchNode];
		 */
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ballSpriteSheet.plist"];
		sheet = [CCSpriteBatchNode batchNodeWithFile:@"ballSpriteSheet.png"];
		[self addChild:sheet];
		
		[self addChild:[ScoreKeeper sharedScoreKeeper].scoreLabel z:100];
		
		//[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		
		timeSinceLastBallDrop = timeBetweenBallDrops = 0.3;
		
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) draw {
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}

-(void) addNewSpriteWithCoords:(CGPoint)p {
	Ball *b = [[Ball alloc] init];
	b.position = ccp(p.x, p.y);
	[self addChild:b];
	
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = b;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	b2CircleShape ballShape;
	ballShape.m_radius = 0.98f*BALL_SCALE;
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &ballShape;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	fixtureDef.restitution = 0.1f;
	body->CreateFixture(&fixtureDef);
}

-(void) tick: (ccTime) dt
{
	if( ![[CCDirector sharedDirector] isPaused]) {
		
		if(state == kPaused) {
			timeLeftBeforeUnpause -= dt;
			if(timeLeftBeforeUnpause < 0)
				state = kNormal;
		} else {
			timeSinceLastBallDrop += dt;
			if(timeSinceLastBallDrop >= timeBetweenBallDrops) {
				timeSinceLastBallDrop -= timeBetweenBallDrops;
				[self addNewSpriteWithCoords:ccp(CCRANDOM_0_1() * [CCDirector sharedDirector].winSize.width, 500)];
				
			}
		}
		
		int32 velocityIterations = 8;
		int32 positionIterations = 1;
		
		// Instruct the world to perform a single step of simulation. It is
		// generally best to keep the time step and iterations fixed.
		world->Step(dt, velocityIterations, positionIterations);
		
		//Iterate over the bodies in the physics world
		for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
		{
			if (b->GetUserData() != NULL) {
				//Synchronize the AtlasSprites position and rotation with the corresponding body
				Ball *myBall = (Ball*)b->GetUserData();
				myBall.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
				myBall.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
			}	
		}
		
		if([self children].count > 120)
		{
			GameOverLayer *gameOver = [[GameOverLayer alloc] init];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5f scene:(CCScene *)gameOver]];
		}
	}
}

//called when the user lifts a finger from the screen
//finds the ball touched by the user and "pops" all same-colored balls touching it (and so on)
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//At the touch's locatio
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
			Ball *userData = (Ball *)b->GetUserData();
			
			if(userData && [userData isKindOfClass:[Ball class]] &&
			   [self distanceFrom:userData.position to:location] < 32*BALL_SCALE) {
				[self popBallsFrom:b];
				if([ScoreKeeper sharedScoreKeeper].currentBallCount > 0)
					[[ScoreKeeper sharedScoreKeeper] updateScore];
				return;
			}
		}
	}
}

//"pops" (i.e. destroys and removes) a ball and recurses on all like-colored balls that touch it
-(void)popBallsFrom:(b2Body *)b {
	
	Ball *ballToRemove = (Ball *)b->GetUserData();
	ballToRemove.visible = NO;
	
	//if the user popped a Pause Ball, switch to Paused mode for 5 seconds
	if(ballToRemove.type == kPause) {
		timeLeftBeforeUnpause = DEFAULT_PAUSE_TIME;
		state = kPaused;
	}
	
	for(b2ContactEdge *bce = b->GetContactList(); bce; bce = bce->next) {
		b2Body *otherBody = bce->other;
		Ball *otherBall = (Ball *)otherBody->GetUserData();
		
		if(otherBody && otherBall && otherBall.visible && otherBall.type == ballToRemove.type
		   && [ballToRemove distanceTo:otherBall] <= 65*BALL_SCALE)
			[self popBallsFrom:otherBody];
	}
	[self removeChild:ballToRemove cleanup:YES];
	world->DestroyBody(b);
	[ScoreKeeper sharedScoreKeeper].currentBallCount++;
}

-(double)distanceFrom:(CGPoint)a to:(CGPoint)b {
	return sqrt( (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y) );
}

/*
 - (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
 {	
 static float prevX=0, prevY=0;
 
 //#define kFilterFactor 0.05f
 #define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
 
 float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
 float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
 
 prevX = accelX;
 prevY = accelY;
 
 // accelerometer values are in "Portrait" mode. Change them to Landscape left
 // multiply the gravity by 10
 b2Vec2 gravity( -accelY * 10, accelX * 10);
 
 world->SetGravity( gravity );
 }
 */

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
