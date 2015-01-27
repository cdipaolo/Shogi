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
#define KNIGHT 4
#define BISHOP 5
#define ROOK 6
#define GOLD 7
#define KING 8

// promoted is original piece + 10
#define PAWNP 11
#define LANCEP 12
#define SILVERP 13
#define KNIGHTP 14
#define BISHOPP 15
#define ROOKP 16


@interface ShogiBoard : NSObject

@property (nonatomic) NSDictionary* numberToLetter;
@property (nonatomic) NSMutableArray* playerCaptures;
@property (nonatomic) NSMutableArray* enemyCaptures;
@property (nonatomic) int numPlayerCaptures;
@property (nonatomic) int numEnemyCaptures;
@property (nonatomic) bool GameOver;
@property (nonatomic) bool PlayerIsWinner;


// returns the correct macro'ed value for a piece. if index out of range returns 255
- (int) pieceAtRowI: (int) i ColumnJ: (int) j;
- (int) pieceAtRowI:(int)i ColumnJ:(int)j forBoard: (int[9][9]) board;
- (int**) returnBoard;
- (void) movePieceAtRow:(int)row column:(int)col toRow:(int)finalRow toColumn:(int)finalCol onBoard:(int[9][9])b forEnemyCaptures:(NSMutableArray**)enemyCap forAllyCaptures:(NSMutableArray**)allyCap promote:(bool)promotePiece;
- (void) movePieceAtRow: (int)row column: (int)col toRow: (int)finalRow toColumn: (int) finalCol promote: (bool)promotePiece;
- (NSArray*) possibleMovesOfPieceAtRow: (NSNumber*)row column: (NSNumber*) col;
- (SKSpriteNode* ) nodeFromPiece:(int)piece;
- (id) initWithArray: (int[9][9]) pieces;
- (id) init;


@end
