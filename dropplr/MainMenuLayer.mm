//
//  MainMenuLayer.m
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "DropplrGameplayLayer.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

@implementation MainMenuLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
    
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        // schedule a repeating callback on every frame
        //[self schedule:@selector(nextFrame:)];
        [self setUpMenus];
        
		// register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
    }
	return self;
}

// set up the Menus
-(void) setUpMenus
{
    //get the background image
/*
    bgImage = [CCSprite spriteWithFile:@"LetterpressSplashScreen.png"];
    bgImage.position = ccp(160,240);
    [self addChild:bgImage];
    
	// Create some menu items
    
    //classic mode
	CCMenuItemImage * menuItemPlay =[CCMenuItemImage itemFromNormalImage:@"bigPlayButton.png"
														   selectedImage: @"bigPlayButtonSelected.png"
																  target:self
																selector:@selector(launchClassicMode)];
	
	
    
    //tutorial
	CCMenuItemImage * menuItemHowTo =[CCMenuItemImage itemFromNormalImage:@"howToButton.png"
															selectedImage: @"howToButtonSelected.png"
																   target:self
																 selector:@selector(launchHowTo)];
    
    //leaderboards
    CCMenuItemImage * menuItemLeaderboards =[CCMenuItemImage itemFromNormalImage:@"leaderboardsButton.png"
																   selectedImage: @"leaderboardsButtonSelected.png"
																		  target:self
																		selector:@selector(launchLeaderboards)];
	
    muteAudioMuted =    [[CCMenuItemImage itemFromNormalImage:@"muteButtonOff.png"
                                                selectedImage:@"muteButtonOffSelected.png"] retain];
    muteAudioUnmuted =  [[CCMenuItemImage itemFromNormalImage:@"muteButtonOn.png"
                                                selectedImage:@"muteButtonOnSelected.png"] retain]; 
    //options
	CCMenuItemToggle * menuItemMuteButton =[CCMenuItemToggle itemWithTarget:self
																   selector:@selector(muteButtonPressed:)
																	  items:muteAudioMuted, muteAudioUnmuted, nil];

    if([[SimpleAudioEngine sharedEngine] mute])
        [menuItemMuteButton setSelectedIndex:0];
    else
        [menuItemMuteButton setSelectedIndex:1];
	
    
	// Create a menu and add your menu items to it
	CCMenu *myMenu = [CCMenu menuWithItems:menuItemPlay, menuItemHowTo, menuItemLeaderboards, menuItemMuteButton, nil];
    
	// Arrange the menu items vertically
	//[myMenu alignItemsVertically];
    myMenu.position = ccp(160, 160);
    menuItemHowTo.position = ccp(-130, -120);
    menuItemLeaderboards.position = ccp(0, -120);
    menuItemMuteButton.position = ccp(130, -120);
	// add the menu to your scene
	[self addChild:myMenu];
	*/
}

//run the main gameplay mode
-(void)launchClassicMode
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5f scene:[DropplrGameplayLayer scene]]];
}

//there is currently no options screen, so this just loads the game
-(void)muteButtonPressed:(id)sender
{
    //load the user preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    BOOL audioAlreadyMuted = [[SimpleAudioEngine sharedEngine] mute];
    [[SimpleAudioEngine sharedEngine] setMute:!audioAlreadyMuted];
    [prefs setBool:!audioAlreadyMuted forKey:@"muteAudio"];
    [prefs synchronize];
}

//run the time attack mode--not currently implemented, so it just runs the regular gameplay mode
-(void)launchTimeAttack
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5f scene:[DropplrGameplayLayer scene]]];
}

//there is currently no tutorial screen, so this just loads the game
-(void)launchTutorial
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.5f scene:[DropplrGameplayLayer scene]]];  
}

//show the GameKit leaderboards
-(void)launchLeaderboards
{
    //[[GameCenterHandler sharedGameCenterHandler] showLeaderBoard];
}

- (void) nextFrame:(ccTime)dt {
	
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	/*
	 CGPoint location = [touch locationInView: [touch view]];
	 CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
     */
}

@end
