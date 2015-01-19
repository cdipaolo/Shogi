//
//  ShogiBoard.h
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteKit/SpriteKit.h"

#define EMPTY 0

#define PAWN 1
#define LANCE 2
#define SILVER 3
#define GOLD 4
#define KNIGHT 5
#define BISHOP 6
#define ROOK 7
#define KING 8

#define PAWNP 9
#define LANCEP 10
#define SILVERP 11
#define KNIGHTP 12
#define BISHOPP 13
#define ROOKP 14


@interface ShogiBoard : NSObject

// returns the correct macro'ed value for a piece. if index out of range returns ~0b0, which is a large number
- (int) pieceAtRowI: (int) i ColumnJ: (int) j;
- (SKSpriteNode* ) nodeFromPiece:(short)piece;
- (id) initWithArray: (int[9][9]) pieces;
- (id) init;


@end
