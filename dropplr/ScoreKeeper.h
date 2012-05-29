//
//  ScoreKeeper.h
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreKeeper : NSObject


@property int score;
@property int currentBallCount;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;
+(ScoreKeeper *)sharedScoreKeeper;
-(void)updateScore;

@end
