//
//  ShogiBoard.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "ShogiBoard.h"


@implementation ShogiBoard

const static int _defaultPieces[9][9] =  {{-LANCE,-KNIGHT,-SILVER,-GOLD,-KING,-GOLD,-SILVER,-KNIGHT,-LANCE},
                                    {EMPTY,-ROOK,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,-BISHOP,EMPTY},
                                    {-PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {PAWN, PAWN, EMPTY/*PAWN*/, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN},
                                    {EMPTY,BISHOP,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,ROOK,EMPTY},
                                    {LANCE,KNIGHT,SILVER,GOLD,KING,GOLD,SILVER,KNIGHT,LANCE}};

// variable private var board representation
static int _pieces[9][9] = {{-LANCE,-KNIGHT,-SILVER,-GOLD,-KING,-GOLD,-SILVER,-KNIGHT,-LANCE},
                                    {EMPTY,-ROOK,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,-BISHOP,EMPTY},
                                    {-PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN},
                                    {EMPTY,BISHOP,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,ROOK,EMPTY},
                                    {LANCE,KNIGHT,SILVER,GOLD,KING,GOLD,SILVER,KNIGHT,LANCE}};


- (int) pieceAtRowI:(int)i ColumnJ:(int)j {
    // still diggin that terniary operator!
    return i<9 && j<9 ? _pieces[i][j]: 255;
}

// move a piece at a location to another location. Does nothing if move not valid
- (void) movePieceAtRow:(int)row column:(int)col toRow:(int)finalRow toColumn:(int)finalCol {
    int pieceMoving = 2; //do stuff here
}

// returns all possible moves of a piece at a location in an NSArray of NSNumbers
//      for each of the possible moves a certain piece can make.
/*      ** Returns nil instance if no possible moves **         */
- (NSArray*) possibleMovesOfPieceAtRow:(NSNumber*)row column:(NSNumber*)col {
    const int piece = [self pieceAtRowI:[row intValue] ColumnJ:[col intValue]];
    int iRow = [row intValue];
    int jCol = [col intValue];
    NSMutableArray* moves = [[NSMutableArray alloc] init];
    
    switch (piece) {
        case PAWN:                                                  // -x-
            if ([self pieceAtRowI: iRow-1 ColumnJ:jCol] > 0){       // -o-
                moves = nil;                                        // ---
            } else {
                [moves addObject:@[  @(iRow-1), col]  ];
            }
            return moves.count > 0 ? moves: nil;
                                                                                        // ...
        case LANCE:                                                                     // -x-
            for (int i = iRow; i>-1; --i){                                              // -x-
                // if piece I'm looking at is either empty, enemy, or ally- do stuff.   // -x-
                int p = [self pieceAtRowI:i ColumnJ:jCol];                              // -o-
                if (p == EMPTY){
                    [moves addObject:@[ [NSNumber numberWithInt:i], col ]];
                } else if (p > 0) {
                    break;
                } else {
                    [moves addObject:@[ [NSNumber numberWithInt:i], col ]];
                    break;
                }
            }
            return moves.count > 0 ? moves : nil;
            
        case SILVER:                                                    //  xxx
            // iterate through top part of available moves              //  -o-
            for (int j = jCol-1; j < jCol+2; ++j){                      //  x-x
                int newPiece = [self pieceAtRowI:iRow-1 ColumnJ:j];
                if ( newPiece < 1 ){
                    [moves addObject:@[ [NSNumber numberWithInt:iRow-1], [NSNumber numberWithInt:j] ]];
                }
            }
            
            // check if bottom left is available
            int bottomLeft = [self pieceAtRowI:iRow+1 ColumnJ:jCol-1];
            if ( bottomLeft < 1 ){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], [NSNumber numberWithInt:jCol-1] ]];
            }
            int bottomRight = [self pieceAtRowI:iRow+1 ColumnJ:jCol+1];
            if ( bottomRight < 1 ){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], [NSNumber numberWithInt:jCol+1] ]];
            }
            return moves.count>0 ? moves : nil;
        
        case GOLD:                                                  // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int bottomMiddle = [self pieceAtRowI:iRow+1 ColumnJ:jCol];
            if (bottomMiddle < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], [NSNumber numberWithInt:jCol] ]];
            }
            return moves.count > 0 ? moves : nil;
            
        case KNIGHT:                                            // x-x
            // check left possible move                         // ---
            if ([self pieceAtRowI:iRow-2 ColumnJ:jCol-1] < 1){  // -o-
                [moves addObject:@[ [NSNumber numberWithInt:iRow-2] , [NSNumber numberWithInt: jCol-1] ]];
            }
            // check right move possible
            if ([self pieceAtRowI:iRow-2 ColumnJ:jCol+1] < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow-2] , [NSNumber numberWithInt: jCol+1] ]];
            }
            return moves.count > 0 ? moves : nil;
        
        case BISHOP:
            // check moves from top right
            for (int i=iRow-1, j=jCol+1; i>-1 && j<9; --i, ++j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j];
                printf("Piece at <%d,%d> is %d\n",i,j,possibleMove);
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    printf("Move at (%d,%d) valid\n", i,j);
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                printf("~Move at (%d,%d) NOT valid- breaking loop\n", i,j);
                break;
            }
            // check moves from top left
            for (int i=iRow-1, j=jCol-1; i>-1 && j>-1; --i, --j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j];
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check moves from bottom left
            for (int i=iRow+1, j=jCol-1; i<9 && j>-1; ++i, --j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j];
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check moves from bottom right
            for (int i=iRow+1, j=jCol+1; i<9 && j<9; ++i, ++j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j];
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            return moves.count > 0 ? moves : nil;
            
        //ADD ROOK, KING, and all promoted pieces...
            
        default:
            return nil;
    }
}

- (int**) returnBoard {
    return _pieces;
}

- (SKSpriteNode*) nodeFromPiece:(short )piece {
    // if piece < 0, the piece is the enemy's and we'll have to rotate!
    SKAction* rotate = piece<0 ? [SKAction rotateByAngle:(CGFloat)M_PI duration:0.0] : nil;
    
    SKSpriteNode* node = [[SKSpriteNode alloc] init];
    
    switch (piece) {
        // match the non-promoted pieces to their node!
        case PAWN:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"p"];
        case LANCE:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"l"];
        case SILVER:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"s"];
        case GOLD:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"g"];
        case KNIGHT:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"n"];
        case BISHOP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"b"];
        case ROOK:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"r"];
        case KING:
            // gotta love that terniary operator... choose Osho or Gyokusho based on whether enemy or not.
            node = piece<0 ? [SKSpriteNode spriteNodeWithImageNamed:@"kO"] : [SKSpriteNode spriteNodeWithImageNamed:@"kG"];
            
        // now for promoted versions of pieces!! :)
        case PAWNP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"pP"];
        case LANCEP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"lP"];
        case SILVERP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"sP"];
        case KNIGHTP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"nP"];
        case BISHOPP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"bP"];
        case ROOKP:
            node =[SKSpriteNode spriteNodeWithImageNamed:@"rP"];
        default:
            NSLog(@"Error 502: %d is not a valid piece integer name", piece);
    }
    
    if (piece < 0){
        [node runAction:rotate];
    }
    
    return node;
}



// initialize a Shogi Board representation based on an array list of the pieces
-(id) initWithArray: (int[9][9]) pieces {
    self = [super init];
    
    if (self){

        self.numberToLetter = @{@PAWN: @"p", @LANCE: @"l", @SILVER: @"s", @GOLD: @"g", @KNIGHT: @"n", @BISHOP: @"b", @ROOK: @"r", @-KING: @"kG", @KING: @"kO", @PAWNP: @"pP", @LANCEP: @"lP", @SILVERP: @"sP", @KNIGHTP: @"nP", @BISHOPP: @"bP", @ROOKP: @"rP"};
        
        for (int i=0; i<9; ++i){
            for(int j=0; j<9; ++j){
                _pieces[i][j] = pieces[i][j];
                printf("%d  ",_pieces[i][j]);
            }printf("\n");
        }
    }
    return self;
}

// init Shogi Board with defualt starting pieces
-(id) init {
    return [self initWithArray: _defaultPieces];
}

@end
