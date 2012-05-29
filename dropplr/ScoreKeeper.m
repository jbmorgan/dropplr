//
//  ScoreKeeper.m
//  dropplr
//
//  Created by JONATHAN B MORGAN on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScoreKeeper.h"

#define LABEL_WIDTH 120
#define LABEL_HEIGHT 30
#define LABEL_PADDING 10
@implementation ScoreKeeper

@synthesize score, currentBallCount, scoreLabel;

static ScoreKeeper *_sharedScoreKeeper = nil;

//gets the global Singleton instance of WordList
+(ScoreKeeper *)sharedScoreKeeper
{
    if(!_sharedScoreKeeper)
        _sharedScoreKeeper = [[self alloc] init];
    
    return _sharedScoreKeeper;
}

-(id)init {
	if(self = [super init]) {
		score = 0;
		scoreLabel = [[CCLabelTTF alloc] initWithString:@"000000000" dimensions:CGSizeMake(LABEL_WIDTH, LABEL_HEIGHT) alignment:UITextAlignmentRight fontName:@"VeraMono.ttf" fontSize:22.0f];
		scoreLabel.position = ccp(320-LABEL_WIDTH/2-LABEL_PADDING,480-LABEL_HEIGHT/2-LABEL_PADDING);
	}
	return self;
}

-(void)updateScore {
	score += 5 * currentBallCount * currentBallCount;
	scoreLabel.string = [NSString stringWithFormat:@"%09i", score];
	currentBallCount = 0;
}

@end
