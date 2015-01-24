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
@property (nonatomic) NSMutableArray* possibleMovesForSelectedPiece;
@property (nonatomic) int gridBoxWidth;

-(void) updateBoard;

@end
