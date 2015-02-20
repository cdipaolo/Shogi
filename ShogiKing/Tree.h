//
//  Tree.h
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/19/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShogiBoard.h"

// game tree implementation with alpha-beta minimax
@interface Minimax : NSObject

@property (nonatomic) ShogiBoard* head;
/*@property (nonatomic) NSMutableArray* tree;
@property (nonatomic) int alpha;
@property (nonatomic) int beta;*/
@property (nonatomic) int depth;

- (void) minimax;
- (ShogiBoard*) minimax: (bool) player withBoard: (ShogiBoard*) board Alpha:(int) a Beta:(int) b Depth: (int) d;
- (id) initWithBoard: (ShogiBoard*) board depth: (int) d;

@end
