//
//  ShogiBoard.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "ShogiBoard.h"

@implementation ShogiBoard

NSArray* _defaultPieces;

-(int64_t) bitboardFromArray:(NSArray* )array forPiece:(NSString* )piece {
    int64_t bitboard = 0b0;
    for (int i=0; i<63; ++i) {
        bitboard |= [[array objectAtIndex:i] isEqualToString:piece] ? 0b1<<(63-i) : 0b0;
    }
    
    return bitboard;
}

// initialize a Shogi Board representation based on an array list of the pieces
-(id) initWithArray: (NSArray*) pieces {
    self = [super init];
    
    if (self){
        
        self.pawn = [self bitboardFromArray:pieces forPiece:@"P"];
        self.knight = [self bitboardFromArray:pieces forPiece:@"N"];
        self.lance = [self bitboardFromArray:pieces forPiece:@"L"];
        self.silver = [self bitboardFromArray:pieces forPiece:@"S"];
        self.gold = [self bitboardFromArray:pieces forPiece:@"G"];
        self.king = [self bitboardFromArray:pieces forPiece:@"K"];
        self.bishop = [self bitboardFromArray:pieces forPiece:@"B"];
        self.rook = [self bitboardFromArray:pieces forPiece:@"R"];
        
        self.pawnE = [self bitboardFromArray:pieces forPiece:@"p"];
        self.knightE = [self bitboardFromArray:pieces forPiece:@"n"];
        self.lanceE = [self bitboardFromArray:pieces forPiece:@"l"];
        self.silverE = [self bitboardFromArray:pieces forPiece:@"s"];
        self.goldE = [self bitboardFromArray:pieces forPiece:@"g"];
        self.kingE = [self bitboardFromArray:pieces forPiece:@"k"];
        self.bishopE = [self bitboardFromArray:pieces forPiece:@"b"];
        self.rookE = [self bitboardFromArray:pieces forPiece:@"r"];
        
        
    }
    return self;
}

// init Shogi Board with defualt starting pieces
-(id) init {
    return [self initWithArray: _defaultPieces];
}

// set default pieces
+(void) initialize{
    if (self == [ShogiBoard class]) {
        _defaultPieces = @[@"l",@"n",@"s",@"g",@"k",@"g",@"s",@"n",@"l",
                           @" ",@"r",@" ",@" ",@" ",@" ",@" ",@"b",@" ",
                           @"p",@"p",@"p",@"p",@"p",@"p",@"p",@"p",@"p",
                           @" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",
                           @" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",
                           @" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",@" ",
                           @"P",@"P",@"P",@"P",@"P",@"P",@"P",@"P",@"P",
                           @" ",@"B",@" ",@" ",@" ",@" ",@" ",@"R",@" ",
                           @"L",@"N",@"S",@"G",@"K",@"G",@"S",@"N",@"L"];
    }
}

@end
