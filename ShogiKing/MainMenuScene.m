//
//  MainMenuScene.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "MainMenuScene.h"
#import "OnePlayerScene.h"
#import "TwoPlayerScene.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"main"];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];

        SKShapeNode* onePlayerGame = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .34, self.frame.size.height * .04)];
        onePlayerGame.name = @"OnePlayerGame";
        onePlayerGame.position = CGPointMake(self.frame.size.width/2 + 5, self.frame.size.height/2 - 15);
        onePlayerGame.hidden = false;
        onePlayerGame.lineWidth = 0;
        onePlayerGame.zPosition++;
        [self addChild:onePlayerGame];
        
        SKShapeNode* computerGame = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width * .34, self.frame.size.height * .04)];
        computerGame.name = @"ComputerGame";
        computerGame.position = CGPointMake(self.frame.size.width/2 + 5, self.frame.size.height/2 - 75);
        computerGame.hidden = false;
        computerGame.lineWidth = 0;
        computerGame.zPosition++;
        [self addChild:computerGame];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    SKNode* nodeTouched = [self nodeAtPoint: [touch previousLocationInNode:self] ];
    NSString* name = nodeTouched.name;
    
    if ([name isEqualToString:@"OnePlayerGame"]){ // Present open game
        printf("Clicked OnePlayerGame from Main Menu...\n\n");
        OnePlayerScene* onePlayer = [[OnePlayerScene alloc] initWithSize:self.size];
        [self.view presentScene:onePlayer];
        
    } else if ([name isEqualToString:@"ComputerGame"]) { // Present game against computer
        printf("Clicked ComputerGame from Main Menu...\n\n");
        TwoPlayerScene* twoPlayer = [[TwoPlayerScene alloc] initWithSize:self.size];
        [self.view presentScene:twoPlayer];
    } else {
        printf("Clicked Away from Buttons...\n");
    }
}

@end
