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
    // dig that terniary operator!
    return i<9 && j<9 ? board[i][j]: 255;
}

// move a piece at a location to another location. Returns the board with b[0][0] changed such that b[0][0]=255
// returns new board - pass by reference capture piles and number of captures
- (void) movePieceAtRow:(int)row column:(int)col toRow:(int)finalRow toColumn:(int)finalCol onBoard:(int[9][9])b promote:(bool)promotePiece{
    NSArray* move = @[ [NSNumber numberWithInt:finalRow] , [NSNumber numberWithInt:finalCol] ];
    
    if ([[self possibleMovesOfPieceAtRow: [NSNumber numberWithInt: row] column: [NSNumber numberWithInt: col]] containsObject:move]) {
        int piece = [self pieceAtRowI:row ColumnJ:col forBoard:b];
        int pieceInFinalLocation = [self pieceAtRowI:finalRow ColumnJ:finalCol forBoard:b];
        
        // regular promotion when moving into promotion area
        if (promotePiece){
            // ally pieces promotion
            if (finalRow < 3 && row > 2 && piece > 0 && piece < GOLD ) piece += 10;
            else if (finalRow > 2 && row < 3 && piece > 0 && piece < GOLD ) piece += 10;
        
            // enemy pieces promotion
            if (finalRow > 5 && row < 6 && piece < 0 && piece < GOLD ) piece -= 10;
            else if (finalRow < 6 && row > 5 && piece < 0 && piece < GOLD ) piece -= 10;
        }
        
        // force promotion for lance, pawn, and knight
        switch (piece) {
            case PAWN:
                if (finalRow < 1) piece += 10;
                break;
            case LANCE:
                if (finalRow < 1) piece += 10;
                break;
            case KNIGHT:
                if (finalRow < 2) piece += 10;
                break;
                
            // enemy pieces
            case -PAWN:
                if (finalRow > 7) piece -= 10;
                break;
            case -LANCE:
                if (finalRow > 7) piece -= 10;
                break;
            case -KNIGHT:
                if (finalRow > 6) piece -= 10;
                
            default:
                break;
        }
        
        
        
        if (pieceInFinalLocation * piece <= 0) { // if pieceInFinalLocation is not an ally
            
            // if piece captures (tested above) add piece to capture pile on correct side
            if (piece < 0 && pieceInFinalLocation > 0) { // if piece is enemy add to enemy capture pile
                if (pieceInFinalLocation > KING)    {
                    [self.enemyCaptures addObject:[NSNumber numberWithInt:-1*(pieceInFinalLocation - 10)]];
                } else {
                    [self.enemyCaptures addObject:[NSNumber numberWithInt:-1*pieceInFinalLocation]];
                }
                
            } else if (pieceInFinalLocation == KING || pieceInFinalLocation == -KING){ // if king is captured --> game over & set winner
                self.PlayerIsWinner = piece < 0 ? false : true;
                self.GameOver = true;
            } else if (piece > 0 && pieceInFinalLocation < 0){ // else add to ally capture pile
                if (pieceInFinalLocation < -KING) {
                    [self.playerCaptures addObject:[NSNumber numberWithInt:-1*(pieceInFinalLocation+10)]];
                } else {
                    [self.playerCaptures addObject:[NSNumber numberWithInt:-1*pieceInFinalLocation]];
                }
            }
            
            b[finalRow][finalCol] = piece;
            b[row][col] = EMPTY;
        }
    }
}

- (void) movePieceAtRow: (int)row column: (int)col toRow: (int)finalRow toColumn: (int) finalCol promote: (bool)promotePiece {
    
    [self movePieceAtRow:row column:col toRow:finalRow toColumn:finalCol onBoard:_pieces promote:promotePiece];
    printf("Enemy Captures: ");for (NSNumber* piece in self.enemyCaptures) printf("%d ", [piece intValue]); printf("\n");
    printf("Player Captures: ");for (NSNumber* piece in self.playerCaptures) printf("%d ", [piece intValue]); printf("\n");
    printf("\n");
    
    printf("\nMoving piece at <%d,%d> to <%d,%d>\n", row, col, finalRow, finalCol);
}

// returns all possible moves of a piece at a location in an NSArray of NSNumbers
//      for each of the possible moves a certain piece can make.
/*      ** Returns nil instance if no possible moves **         */
- (NSArray*) possibleMovesOfPieceAtRow:(NSNumber*)row column:(NSNumber*)col {
    
    if (self.GameOver) return nil;
    
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
            for (int i = iRow-1; i>-1; --i){                                              // -x-
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
                    if (i < 0 || j < 0 || j > 8) continue;
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
                                                                                       // x---x
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
                    if (i < 0 || j < 0 || j > 8) continue;
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
                    if (i < 0 || j < 0 || j > 8) continue;
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
                    if (i < 0 || j < 0 || j > 8) continue;
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
                    if (i < 0 || j < 0 || j > 8) continue;
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
            for (int i=iRow-1, j=jCol+1; i>-1 && j<9; --i, ++j){                       // -xox-
                int possibleMove = [self pieceAtRowI:i ColumnJ:j forBoard:b];          // -xxx-
                if (possibleMove < 1){                                                 // x---x
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:j] ]];
                    if (possibleMove == EMPTY){
                        continue;
                    } else {
                        break;
                    }
                }
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
            // check horizontal moves
            for (int j = jCol-1; j<jCol+2; ++j) {
                int possibleMove = [self pieceAtRowI:iRow ColumnJ:j];
                if (possibleMove < 1 && j != jCol){
                    [moves addObject:@[ [NSNumber numberWithInt:iRow] , [NSNumber numberWithInt:j]]];
                }
            }
            // check vertical moves
            for (int i = iRow-1; i<iRow+2; ++i) {
                if (i < 0) continue;
                int possibleMove = [self pieceAtRowI:i ColumnJ:jCol];
                if (possibleMove < 1 && i != iRow){
                    [moves addObject:@[ [NSNumber numberWithInt:i] , [NSNumber numberWithInt:jCol]]];
                }
            }
            break;


        case ROOKP: // rook += king-like box                                           // --x--
            // check from piece up                                                     // -xxx-
            for (int i=iRow-1; i > -1 ; --i ){                                         // xxoxx
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
            for (int j = jCol-1; j > -1; ++j){
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
            // check diagonal pieces...
            int upperRight = [self pieceAtRowI:iRow-1 ColumnJ:jCol+1];
            int upperLeft = [self pieceAtRowI:iRow-1 ColumnJ:jCol-1];
            int bottomLeftDiag = [self pieceAtRowI:iRow+1 ColumnJ:jCol-1];
            int bottomRightDiag = [self pieceAtRowI:iRow+1 ColumnJ:jCol+1];
            
            if (upperRight < 1) [moves addObject:@[[NSNumber numberWithInt:iRow-1],[NSNumber numberWithInt:jCol+1]]];
            if (upperLeft < 1) [moves addObject:@[[NSNumber numberWithInt:iRow-1],[NSNumber numberWithInt:jCol-1]]];
            if (bottomLeftDiag < 1) [moves addObject:@[[NSNumber numberWithInt:iRow+1],[NSNumber numberWithInt:jCol-1]]];
            if (bottomRightDiag < 1) [moves addObject:@[[NSNumber numberWithInt:iRow+1],[NSNumber numberWithInt:jCol+1]]];
            
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

- (SKSpriteNode*) nodeFromPiece:(int)piece {
    // if piece < 0, the piece is the enemy's and we'll have to rotate!
    SKAction* rotate = piece<0 ? [SKAction rotateByAngle:(CGFloat)M_PI duration:0.0] : nil;
    
    SKSpriteNode* node = [[SKSpriteNode alloc] init];
    
    // |piece| is the value as a piece disregarding player
    int absPiece = piece > 0 ? piece : -piece;
    if (piece == -KING) {
        node = [SKSpriteNode spriteNodeWithImageNamed:[self.numberToLetter objectForKey:[NSNumber numberWithInt:piece]]];
    }else if (absPiece > EMPTY && absPiece < 25) { // if piece is a valid piece!
        node = [SKSpriteNode spriteNodeWithImageNamed:[self.numberToLetter objectForKey:[NSNumber numberWithInt:absPiece]]];
    } else if (absPiece == EMPTY) {
        node = nil;
    }else {
        NSLog(@"Error 502: <%d> is not a valid piece integer name", piece);
        node = nil;
    }

    
    if (piece < 0){
        [node runAction:rotate];
    }
    
    return node;
}


- (NSArray*) possibleDropsForPiece:(int)piece onBoard:(int[9][9])b forCaptures:(NSMutableArray*)caps {
    NSMutableArray* moves = [[NSMutableArray alloc] init];
    int absPiece = piece < 0 ? -1*piece : piece;
    
    if (absPiece < 0 || absPiece > 7) {
        return nil;
    }
    
    int flippedBoard[9][9];
    if (piece < 0) {
        for (int i=0; i<9; ++i){
            for (int j=0; j<9; ++j){
                flippedBoard[8-i][8-j] = -1*b[i][j];
            }
        }
    } else {
        for (int i=0; i<9; ++i){
            for (int j=0; j<9; ++j){
                flippedBoard[i][j] = b[i][j];
            }
        }
    }
    
    switch (absPiece) {
        // pawn can't be droppin in last row, or in row with another unpromoted pawn
        //     or to check-mate the king
        // Will implement the check-mate checking later b/c it'll work better once we have AI set up
        case PAWN:
            for (int j=0; j<9; ++j){
                NSMutableArray* array = [[NSMutableArray alloc] init];
                bool broke = false;
                for (int i=1; i<9; ++i){
                    int pieceInFinalLocation = [self pieceAtRowI:i ColumnJ:j forBoard:flippedBoard];
                    if (pieceInFinalLocation == EMPTY){
                        [array addObject:@[[NSNumber numberWithInt:i],[NSNumber numberWithInt:j]]];
                    } else if (pieceInFinalLocation == PAWN) {
                        broke = true;
                    }
                }
                if (broke == false){
                    [moves addObjectsFromArray:array];
                }
            }
            break;
            
        // knight can't be dropped in last two rows
        case KNIGHT:
            for (int i=2; i<9; ++i){
                for (int j=0; j<9; ++j){
                    int pieceInFinalLocation = [self pieceAtRowI:i ColumnJ:j forBoard:flippedBoard];
                    if (pieceInFinalLocation == EMPTY){
                        [moves addObject:@[[NSNumber numberWithInt:i],[NSNumber numberWithInt:j]]];
                    }
                }
            }
            break;
            
            
        // lance cannot be dropped in last row
        case LANCE:
            for (int i=1; i<9; ++i){
                for (int j=0; j<9; ++j){
                    int pieceInFinalLocation = [self pieceAtRowI:i ColumnJ:j forBoard:flippedBoard];
                    if (pieceInFinalLocation == EMPTY){
                        [moves addObject:@[[NSNumber numberWithInt:i],[NSNumber numberWithInt:j]]];
                    }
                }
            }
            break;
                
            
        // all other pieces have open drops
        default:
            for (int i=0; i<9; ++i){
                for (int j=0; j<9; ++j){
                    int pieceInFinalLocation = [self pieceAtRowI:i ColumnJ:j forBoard:flippedBoard];
                    if (pieceInFinalLocation == EMPTY){
                        [moves addObject:@[[NSNumber numberWithInt:i],[NSNumber numberWithInt:j]]];
                    }
                }
            }
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

- (NSArray*) possibleDropsForPiece:(int)piece {
    if (piece < 0 && !self.GameOver){
        return [self possibleDropsForPiece:piece onBoard:_pieces forCaptures:self.enemyCaptures];
    } else {
        return [self possibleDropsForPiece:piece onBoard:_pieces forCaptures:self.playerCaptures];
    }
}

- (void) dropPiece:(int)piece forCaptures:(NSMutableArray*)caps toRowI:(NSNumber*)row colJ:(NSNumber*)col {
    NSLog(@"Dropping piece %d to <%@,%@>\n", piece, row, col);
    bool pieceInCaps = [caps containsObject:[NSNumber numberWithInt:piece]];

    bool moveValid = [[self possibleDropsForPiece:piece] containsObject:@[row, col]];
    
    // if piece is in capture pile and the move is valid--> proceed with the drop
    if (pieceInCaps * moveValid) {
        printf("Move valid...");
        [caps removeObject:[NSNumber numberWithInt:piece]];
        _pieces[[row intValue]][[col intValue]] = piece;
    }
}

- (void) dropPiece:(int)piece toRowI:(NSNumber*)row colJ:(NSNumber*)col {
    if (piece < 0) {
        [self dropPiece:piece forCaptures:self.enemyCaptures toRowI:row colJ:col];
    } else {
        [self dropPiece:piece forCaptures:self.playerCaptures toRowI:row colJ:col];
    }
}


// initialize a Shogi Board representation based on an array list of the pieces
// must send a 9x9 array of pieces
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
        
        self.playerCaptures = [[NSMutableArray alloc] init];
        self.numPlayerCaptures = 0;
        
        self.enemyCaptures = [[NSMutableArray alloc] init];
        self.numEnemyCaptures = 0;
        
        self.GameOver = false;
        self.PlayerIsWinner = false;
    }
    return self;
}

// init Shogi Board with defualt starting pieces
-(id) init {
    return [self initWithArray: _defaultPieces];
}


@end
