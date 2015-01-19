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
    return i<9 && j<9 ? _pieces[i][j]: ~0b0;
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
