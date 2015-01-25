//
//  OnePlayerScene.h
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShogiBoard.h"

@interface OnePlayerScene : SKScene

@property (nonatomic) ShogiBoard* board;
@property (nonatomic) NSMutableArray* selectedPiece;
@property (nonatomic) int gridBoxWidth;
@property (nonatomic) bool possibleMovesShowing;

-(void) updateBoard;
-(void) showPossibleMovesForPiece: (SKSpriteNode*)piece;
-(void) showPossibleMovesFromArray:(NSArray*)moves;
-(NSArray*) indicesForNode: (SKNode* )node;

@end
