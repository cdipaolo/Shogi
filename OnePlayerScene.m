//
//  OnePlayerScene.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "OnePlayerScene.h"
#import "ShogiBoard.h"

@implementation OnePlayerScene


-(id) initWithSize:(CGSize)size {
    if ([super initWithSize:size]) {
        
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"gameSceneBlank"];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];
        
        SKShapeNode* boardArea = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .965, self.frame.size.width * .97)];
        boardArea.name = @"BoardArea";
        boardArea.position = CGPointMake(self.frame.size.width/2 + 1, self.frame.size.height/2);
        boardArea.lineWidth = 1;
        boardArea.zPosition++;
        [self addChild:boardArea];
        
        SKShapeNode* profilePlayer = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .095, self.frame.size.width * .0946)];
        profilePlayer.name = @"PlayerProfilePic";
        profilePlayer.position = CGPointMake(self.frame.size.width * .068, self.frame.size.height * .073);
        profilePlayer.zPosition++;
        profilePlayer.lineWidth = 0;
        [self addChild:profilePlayer];
        
        SKShapeNode* profileEnemy = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .095, self.frame.size.width * .0946)];
        profileEnemy.name = @"PlayerProfilePic";
        profileEnemy.position = CGPointMake(self.frame.size.width * .933, self.frame.size.height * .9245);
        profileEnemy.zPosition++;
        profileEnemy.lineWidth = 0;
        [self addChild:profileEnemy];
        
        //Shogi Board allocation from custom class
        self.board = [[ShogiBoard alloc] init];
        
        self.gridBoxWidth = boardArea.frame.size.width / 9;
        self.possibleMovesForSelectedPiece = [[NSMutableArray alloc] init];
        
        // update the board
        [self updateBoard];
        
    }
    return self;
}

// go through each piece, remove from parent, and reallocate correct piece for self.board reresentation
// may want to make this more efficient in the futute...
-(void) updateBoard {
    SKShapeNode* boardArea = (SKShapeNode*)[self childNodeWithName:@"BoardArea"];
    
    // delete all children!! muahahahahahahahaha >:)
    [boardArea removeAllChildren];
    
    // RECREATE the CHILDREN!!
    for (int i=0; i<9; ++i){
        for (int j=0; j<9; ++j){
            SKSpriteNode* piece = [self.board nodeFromPiece:[self.board pieceAtRowI:i ColumnJ:j]];
            
            if (piece != nil) {
                piece.position = CGPointMake(self.gridBoxWidth * (4-j), self.gridBoxWidth * (4-i));
                //piece.position = CGPointMake(0, 0);
                [boardArea addChild:piece];
            }
            
        }
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end
