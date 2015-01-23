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
                                    {-PAWN, /*-PAWN*/EMPTY, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN, -PAWN},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY},
                                    {PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN, PAWN},
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

- (int) pieceAtRowI:(int)i ColumnJ:(int)j forBoard: (int[9][9]) board {
    // still diggin that terniary operator!
    return i<9 && j<9 ? board[i][j]: 255;
}

// move a piece at a location to another location. Does nothing if move not valid
- (void) movePieceAtRow:(int)row column:(int)col toRow:(int)finalRow toColumn:(int)finalCol {
    //do stuff here
}

// returns all possible moves of a piece at a location in an NSArray of NSNumbers
//      for each of the possible moves a certain piece can make.
/*      ** Returns nil instance if no possible moves **         */
- (NSArray*) possibleMovesOfPieceAtRow:(NSNumber*)row column:(NSNumber*)col {
    const int piece = [self pieceAtRowI:[row intValue] ColumnJ:[col intValue]];
    const int flippedPiece = piece < 0 ? -1 * piece : piece;
    
    int iRow = piece < 0 ? 8-[row intValue] : [row intValue];
    int jCol = piece < 0 ? 8-[col intValue] : [col intValue];
    
    int b[9][9];
    if (piece > -1) {
        for (int i = 0; i<9; ++i){
            for (int j=0; j<9; ++j){
                b[i][j] = _pieces[i][j];
            }
        }
    } else {
        // else 'flip' the board π rad to see from enemy's side
        for (int i=8; i > -1; --i){
            for (int j=8; j > -1; --j){
                b[8-i][8-j] = -1 * _pieces[i][j];
            }
        }
        // switch col and row
        row = [NSNumber numberWithInt:iRow];
        col = [NSNumber numberWithInt:jCol];
    }

    
    NSMutableArray* moves = [[NSMutableArray alloc] init];
    
    switch (flippedPiece) {
        case PAWN:                                                             // -x-
            if ([self pieceAtRowI: iRow-1 ColumnJ:jCol forBoard:b] > 0){       // -o-
                moves = nil;                                                   // ---
            } else {
                [moves addObject:@[  @(iRow-1), col]  ];
            }
            break;
                                                                                        // ...
        case LANCE:                                                                     // -x-
            for (int i = iRow; i>-1; --i){                                              // -x-
                // if piece I'm looking at is either empty, enemy, or ally- do stuff.   // -x-
                int p = [self pieceAtRowI:i ColumnJ:jCol forBoard:b];                   // -o-
                if (p == EMPTY){
                    [moves addObject:@[ [NSNumber numberWithInt:i], col ]];
                } else if (p > 0) {
                    break;
                } else {
                    [moves addObject:@[ [NSNumber numberWithInt:i], col ]];
                    break;
                }
            }
            break;

            
        case SILVER:                                                    //  xxx
            // iterate through top part of available moves              //  -o-
            for (int j = jCol-1; j < jCol+2; ++j){                      //  x-x
                int newPiece = [self pieceAtRowI:iRow-1 ColumnJ:j  forBoard:b];
                if ( newPiece < 1 ){
                    [moves addObject:@[ [NSNumber numberWithInt:iRow-1], [NSNumber numberWithInt:j] ]];
                }
            }
            
            // check if bottom left is available
            int bottomLeft = [self pieceAtRowI:iRow+1 ColumnJ:jCol-1 forBoard:b];
            if ( bottomLeft < 1 ){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], [NSNumber numberWithInt:jCol-1] ]];
            }
            int bottomRight = [self pieceAtRowI:iRow+1 ColumnJ:jCol+1 forBoard:b];
            if ( bottomRight < 1 ){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], [NSNumber numberWithInt:jCol+1] ]];
            }
            break;
        
        case GOLD:                                                  // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int bottomMiddle = [self pieceAtRowI:iRow+1 ColumnJ:jCol forBoard:b];
            if (bottomMiddle < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], col ]];
            }
            break;

            
        case KNIGHT:                                                       // x-x
            // check left possible move                                    // ---
            if ([self pieceAtRowI:iRow-2 ColumnJ:jCol-1 forBoard:b] < 1){  // -o-
                [moves addObject:@[ [NSNumber numberWithInt:iRow-2] , [NSNumber numberWithInt: jCol-1] ]];
            }
            // check right move possible
            if ([self pieceAtRowI:iRow-2 ColumnJ:jCol+1 forBoard:b] < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow-2] , [NSNumber numberWithInt: jCol+1] ]];
            }
            break;

        
        case BISHOP:                                                                   // x---x
            // check moves from top right                                              // -x-x-
            for (int i=iRow-1, j=jCol+1; i>-1 && j<9; --i, ++j){                       // --o--
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];          // -x-x-
                printf("Piece at <%d,%d> is %d\n",i,j,possibleMove);                   // x---x
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
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
            break;

            
        case ROOK:                                                                     // --x--
            // check from piece up                                                     // --x--
            for (int i=iRow-1; i > -1 ; --i ){                                         // xxoxx
                int possibleMove = [self pieceAtRowI:i ColumnJ:jCol forBoard:b];       // --x--
                if (possibleMove < 1){                                                 // --x--
                    [moves addObject:@[ [NSNumber numberWithInt:i] , col ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to down
            for (int i=iRow+1; i < 9 ; ++i ){
                int possibleMove = [self pieceAtRowI:i ColumnJ:jCol forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , col ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to left
            for (int j = jCol-1; j > -1; --j){
                int possibleMove = [self pieceAtRowI:iRow ColumnJ:j forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ row , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to right
            for (int j = jCol+1; j < 9; ++j){
                int possibleMove = [self pieceAtRowI:iRow ColumnJ:j forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ row , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            break;

        
        case KING:                                                                  // xxx
            // loop through all pieces in the box- even checking the king itself    // xox
            for (int i=iRow-1; i<iRow+2; ++i){                                      // xxx
                for (int j=jCol-1; j<jCol+2; ++j){
                    int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if (possibleMove < 1){
                        [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            break;

            
        // now onwards to promoted pieces!! hazzah!
        
        case PAWNP:  // promoted pawn is a Gold Gen.
            /* use same code as Gold General */                     // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int bottomMiddlePiece = [self pieceAtRowI:iRow+1 ColumnJ:jCol forBoard:b];
            if (bottomMiddlePiece < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], col ]];
            }
            break;

        
        case LANCEP:  // promoted lance is a Gold Gen.
            /* use same code as Gold General */                     // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int bottomMiddleMove = [self pieceAtRowI:iRow+1 ColumnJ:jCol forBoard:b];
            if (bottomMiddleMove < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], col ]];
            }
            break;

            
        case SILVERP:  // promoted silver is a Gold Gen.
            /* use same code as Gold General */                     // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int lowerMiddlePiece = [self pieceAtRowI:iRow+1 ColumnJ:jCol forBoard:b];
            if (lowerMiddlePiece < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], col ]];
            }
            break;

            
        case KNIGHTP:  // promoted knight is a Gold Gen.
            /* use same code as Gold General */                     // xxx
            // iterate through top and middle in box of moves       // xox
            for (int i = iRow-1; i < iRow+1; ++i){                  // -x-
                for (int j = jCol-1; j<jCol+2; ++j){
                    int newPiece = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if ( newPiece < 1 ){
                        [moves addObject:@[ [NSNumber numberWithInt:i], [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            // check the middle lower possible move
            int bottomMiddlePieceKnightP = [self pieceAtRowI:iRow+1 ColumnJ:jCol forBoard:b];
            if (bottomMiddlePieceKnightP < 1){
                [moves addObject:@[ [NSNumber numberWithInt:iRow+1], col ]];
            }
            break;
            
        case BISHOPP:   // bishop += king-like box                                     // x---x
            // check moves from top right                                              // -xxx-
            for (int i=iRow-2, j=jCol+2; i>-1 && j<9; --i, ++j){                       // -xox-
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];          // -xxx-
                if (possibleMove < 1){                                                 // x---x
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check moves from top left
            for (int i=iRow-2, j=jCol-2; i>-1 && j>-1; --i, --j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
            for (int i=iRow+2, j=jCol-2; i<9 && j>-1; ++i, --j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
            for (int i=iRow+2, j=jCol+2; i<9 && j<9; ++i, ++j){
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
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
            // check the box! using same code as king... so including the bishop which it'll pass over.
            for (int i=iRow-1; i<iRow+2; ++i){
                for (int j=jCol-1; j<jCol+2; ++j){
                    int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if (possibleMove < 1){
                        [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            break;


        case ROOKP: // rook += king-like box                                           // --x--
            // check from piece up                                                     // -xxx-
            for (int i=iRow-2; i > -1 ; --i ){                                         // xxoxx
                int possibleMove = [self pieceAtRowI:i ColumnJ:jCol forBoard:b];       // -xxx-
                if (possibleMove < 1){                                                 // --x--
                    [moves addObject:@[ [NSNumber numberWithInt:i] , col ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to down
            for (int i=iRow+2; i < 9 ; ++i ){
                int possibleMove = [self pieceAtRowI:i ColumnJ:jCol forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , col ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to left
            for (int j = jCol-2; j > -1; ++j){
                int possibleMove = [self pieceAtRowI:iRow ColumnJ:j forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ row , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check from piece to right
            for (int j = jCol+2; j < 9; ++j){
                int possibleMove = [self pieceAtRowI:iRow ColumnJ:j forBoard:b];
                if (possibleMove < 1){
                    [moves addObject:@[ row , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == 0){
                        continue;
                    } else {
                        break;
                    }
                }
                break;
            }
            // check the box using same code as king... pass over bishop
            for (int i=iRow-1; i<iRow+2; ++i){
                for (int j=jCol-1; j<jCol+2; ++j){
                    int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];
                    if (possibleMove < 1){
                        [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    }
                }
            }
            break;
            
        default:
            break;
    }
    
    if (piece < 0 && moves.count > 0){
        NSMutableArray* flippedMoves = [[NSMutableArray alloc] init];
        
        for (NSArray* move in moves){
            int i = 8 - [[move objectAtIndex:0] intValue];
            int j = 8 - [[move objectAtIndex:1] intValue];
            [flippedMoves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ] ];
        }
        
        return flippedMoves;
    }
    
    return moves.count > 0 ? moves : nil;
}

- (int**) returnBoard {
    printf("\nReturning board:: \n");
    for (int i=0; i<9; ++i){
        for(int j=0; j<9; ++j){
            printf("%d  ",_pieces[i][j]);
        }printf("\n");
    }
    return _pieces;
}

/*- (int**) returnBoardFlipped: (int[9][9]) board {
    int** newPieces = malloc(81 * sizeof(int));
    for (int i=8; i > -1; --i){
        for (int j=8; j > -1; --j){
            int tmp = -1 * board[i][j];
            newPieces[8-i][8-j] = tmp;
        }
    }
    return newPieces;
}*/

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
