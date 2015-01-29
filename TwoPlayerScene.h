//
//  OnePlayerScene.h
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShogiBoard.h"

@interface TwoPlayerScene : SKScene

@property (nonatomic) ShogiBoard* board;
@property (nonatomic) NSMutableArray* selectedPiece;
@property (nonatomic) int gridBoxWidth;
@property (nonatomic) int capGridBoxWidth;
@property (nonatomic) bool possibleMovesShowing;
@property (nonatomic) bool gameMenuShowing;
@property (nonatomic) bool promotedPieceOptionShowing;
@property (nonatomic) NSMutableArray* selectedMove;
@property (nonatomic) NSMutableArray* indices;
@property (nonatomic) int selectedDropPiece;

-(void) updateBoard;
-(void) showGameMenu;
-(void) hideGameMenu;
-(void) showPromotionOptionForPiece:(int)piece;
-(void) hidePromotionOptionPiece;
-(void) showPossibleDropsForPiece: (SKSpriteNode*)piece;
-(void) showPossibleMovesFromArray:(NSArray*)moves;
-(NSArray*) indicesForNode: (SKNode* )node;

@end
