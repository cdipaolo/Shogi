//
//  MainMenuScene.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "MainMenuScene.h"
#import "ShogiBoard.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"main"];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];
        
        SKShapeNode* onePlayerGame = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(255, 45)];
        //onePlayerGame.fillColor = [UIColor whiteColor];
        onePlayerGame.name = @"OnePlayerGame";
        onePlayerGame.position = CGPointMake(self.frame.size.width/2 + 5, self.frame.size.height/2 - 15);
        onePlayerGame.hidden = false;
        onePlayerGame.zPosition++;
        [self addChild:onePlayerGame];
        
        SKShapeNode* ComputerGame = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(255, 45)];
        //ComputerGame.fillColor = [UIColor whiteColor];
        ComputerGame.name = @"ComputerGame";
        ComputerGame.position = CGPointMake(self.frame.size.width/2 + 5, self.frame.size.height/2 - 75);
        ComputerGame.hidden = false;
        ComputerGame.zPosition++;
        [self addChild:ComputerGame];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
