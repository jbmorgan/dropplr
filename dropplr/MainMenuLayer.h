//
//  MainMenuLayer.h
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer
+(id) scene;
-(void)setUpMenus;
-(void)launchClassicMode;
-(void)muteButtonPressed:(id)sender;
-(void)launchLeaderboards;
-(void)launchTutorial;

@end
