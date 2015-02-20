//
//  Tree.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/19/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "Tree.h"

@implementation Minimax

- (void) minimax {
    ShogiBoard* bestMove = [self minimax:self.head.playerTurn withBoard:self.head Alpha:-255 Beta:255 Depth:1];
    // set head's board to the minimax of the board
    [self.head matchBoard:bestMove];
}

- (ShogiBoard*) minimax: (bool) allyTurn withBoard: (ShogiBoard*) board Alpha:(int) a Beta:(int) b Depth:(int) d {
    NSMutableArray* children = [[NSMutableArray alloc] init];
    if (d > self.depth) return nil;
    self.depth++;
    
    for (int i=0; i<9; ++i) {
        for (int j=0; j<9; ++j) {
            int piece = [board pieceAtRowI:i ColumnJ:j];
            
            if (piece > 0 && allyTurn) {
                NSMutableArray* moves = [[NSMutableArray alloc] init];
                [moves addObject:[board possibleMovesOfPieceAtRow:[[NSNumber alloc] initWithInt:i] column:[[NSNumber alloc] initWithInt:j]]];
                
                // add mutated state boards to children
                for (NSArray* move in moves){
                    ShogiBoard* copy = [board copy];
                    [copy movePieceAtRow:i column:j toRow:[[move objectAtIndex:0] intValue] toColumn:[[move objectAtIndex:1] intValue] promote:true];
                    if (copy.evaluation > a && copy.evaluation < b) {[children addObject:copy]; a = copy.evaluation;}
                    
                    if ([copy pieceAtRowI:[[move objectAtIndex:0] intValue] ColumnJ:[[move objectAtIndex:1] intValue] ] != piece) {
                        ShogiBoard* promoteCopy = [board copy];
                        [promoteCopy movePieceAtRow:i column:j toRow:[[move objectAtIndex:0] intValue] toColumn:[[move objectAtIndex:1] intValue] promote:false];
                        if (promoteCopy.evaluation > a && promoteCopy.evaluation < b) {[children addObject:promoteCopy]; a = promoteCopy.evaluation;}
                    }
                    
                }
                if ([children count] == 0) return nil;
                // find the best board from children on tree recursively
                while (children.count > 1) {
                    ShogiBoard* currentBoard = [self minimax:!allyTurn withBoard:[children objectAtIndex:0] Alpha:a Beta:b Depth:d];
                    ShogiBoard* nextBoard = [self minimax:!allyTurn withBoard:[children objectAtIndex:1] Alpha:a Beta:b Depth:d];
                    
                    int current = [currentBoard evaluation];
                    int next = [nextBoard evaluation];
                    
                    if (currentBoard == nil && nextBoard != nil) {
                        [children removeObjectAtIndex:0];
                    } else if (currentBoard != nil && nextBoard == nil) {
                        [children removeObjectAtIndex:1];
                    } else if (currentBoard == nil && nextBoard == nil) {
                        [children removeObjectAtIndex:0];
                        [children removeObjectAtIndex:1];
                    } else if (current > next) {
                        [children removeObjectAtIndex:1];
                    } else {
                        [children removeObjectAtIndex:0];
                    }
                }
                return children.count > 0 ? [children objectAtIndex:0] : nil;
                
            } else if (piece < 0 && !allyTurn) {
                NSMutableArray* moves = [[NSMutableArray alloc] init];
                [moves addObject:[board possibleMovesOfPieceAtRow:[[NSNumber alloc] initWithInt:i] column:[[NSNumber alloc] initWithInt:j]]];
                
                // add mutated state boards to children
                for (NSArray* move in moves){
                    ShogiBoard* copy = [board copy];
                    [copy movePieceAtRow:i column:j toRow:[[move objectAtIndex:0] intValue] toColumn:[[move objectAtIndex:1] intValue] promote:true];
                    if (copy.evaluation > a && copy.evaluation < b) {[children addObject:copy]; b = copy.evaluation;}
                    
                    if ([copy pieceAtRowI:[[move objectAtIndex:0] intValue] ColumnJ:[[move objectAtIndex:1] intValue] ] != piece) {
                        ShogiBoard* promoteCopy = [board copy];
                        [promoteCopy movePieceAtRow:i column:j toRow:[[move objectAtIndex:0] intValue] toColumn:[[move objectAtIndex:1] intValue] promote:false];
                        if (promoteCopy.evaluation > a && promoteCopy.evaluation < b) {[children addObject:promoteCopy]; b = promoteCopy.evaluation;}
                    }
                }
                if ([children count] == 0) return nil;
                // find the best board from children on tree recursively
                while (children.count > 1) {
                    ShogiBoard* currentBoard = [self minimax:!allyTurn withBoard:[children objectAtIndex:0] Alpha:a Beta:b Depth:d];
                    ShogiBoard* nextBoard = [self minimax:!allyTurn withBoard:[children objectAtIndex:1] Alpha:a Beta:b Depth:d];
                    
                    int current = [currentBoard evaluation];
                    int next = [nextBoard evaluation];
                    
                    if (currentBoard == nil && nextBoard != nil) {
                        [children removeObjectAtIndex:0];
                    } else if (currentBoard != nil && nextBoard == nil) {
                        [children removeObjectAtIndex:1];
                    } else if (currentBoard == nil && nextBoard == nil) {
                        [children removeObjectAtIndex:0];
                        [children removeObjectAtIndex:1];
                    } else if (current < next) {
                        [children removeObjectAtIndex:1];
                    } else {
                        [children removeObjectAtIndex:0];
                    }
                }
                return children.count > 0 ? [children objectAtIndex:0] : nil;
                
            }
        }
    }
    return board;
}

- (id) initWithBoard: (ShogiBoard*) board depth: (int) d {
    self = [super init];
    if (self) {self.head = board; self.depth = d;}
    return self;
}

@end
