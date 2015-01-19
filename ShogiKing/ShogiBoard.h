//
//  ShogiBoard.h
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShogiBoard : NSObject


// players pieces bitboards
@property (nonatomic) int64_t pawn;
@property (nonatomic) int64_t knight;
@property (nonatomic) int64_t lance;
@property (nonatomic) int64_t silver;
@property (nonatomic) int64_t gold;
@property (nonatomic) int64_t king;
@property (nonatomic) int64_t bishop;
@property (nonatomic) int64_t rook;

// enemy pieces bitboards
@property (nonatomic) int64_t pawnE;
@property (nonatomic) int64_t knightE;
@property (nonatomic) int64_t lanceE;
@property (nonatomic) int64_t silverE;
@property (nonatomic) int64_t goldE;
@property (nonatomic) int64_t kingE;
@property (nonatomic) int64_t bishopE;
@property (nonatomic) int64_t rookE;


- (int64_t) bitboardFromArray:(NSArray*)array forPiece:(NSString* )piece;
- (id) initWithArray: (NSArray*) pieces;
- (id) init;
+ (void) initialize;


@end
