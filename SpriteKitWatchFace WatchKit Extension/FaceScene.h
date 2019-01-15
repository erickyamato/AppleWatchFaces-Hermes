//
//  FaceScene.h
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Types.h"

NS_ASSUME_NONNULL_BEGIN



@interface FaceScene : SKScene <SKSceneDelegate>

-(void)refreshTheme;
-(void)nextTypeface;
-(void)nextColorRegionStyle;

@property Theme theme;
@property DialStyle dialStyle;
@property ColorRegionStyle colorRegionStyle;
@property Typeface typeface;

@property SKColor *colorRegionColor;
@property SKColor *faceBackgroundColor;
@property SKColor *handColor;
@property SKColor *secondHandColor;
@property SKColor *inlayColor;

@property SKSpriteNode *datePlaceHolder;

@property SKColor *majorMarkColor;
@property SKColor *minorMarkColor;
@property SKColor *textColor;

@property SKColor *alternateMajorMarkColor;
@property SKColor *alternateMinorMarkColor;
@property SKColor *alternateTextColor;

@property BOOL useMasking;

@property BOOL useAlternateColorOnLogosAndDate;

@property CGSize faceSize;
@property SKSpriteNode *dateNumberImgRef;
@property SKSpriteNode *logo1;
@property SKSpriteNode *logo2;
@property SKSpriteNode *logo3;


@end





NS_ASSUME_NONNULL_END
