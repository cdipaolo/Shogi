//
//  MainMenuScene.m
//  ShogiKing
//
//  Created by Conner DiPaolo on 1/18/15.
//  Copyright (c) 2015 Conner DiPaolo. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode* bg = [SKSpriteNode spriteNodeWithImageNamed:@"main"];
        bg.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:bg];
        
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
