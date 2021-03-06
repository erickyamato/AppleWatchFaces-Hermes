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
-(void)nextColorDialStyle;
-(void)changeEditModeTo:(EditMode)editMode;
-(void)resetStyles;
-(void)resetCurrentFaceStyle;

@property Theme theme;
@property DuotoneMode duotoneMode;
@property DateFontIdentifier dateFontIdentifier;
@property EditMode crownEditMode;

@property SKColor *bgColor1;
@property SKColor *bgColor2;
@property SKColor *hourMinuteColor;
@property SKColor *secondsHandColor;
@property SKColor *innerColor;
@property SKColor *outerColor;
@property SKColor *typefaceColor;
@property SKColor *logoAndDateColor;

@property SKSpriteNode *datePlaceHolder;

@property SKColor *alternateTextColor;

@property BOOL useMasking;

@property BOOL showSeconds;

@property BOOL updatingTypeFace;

@property BOOL useAlternateColorOnLogosAndDate;

@property CGSize faceSize;
@property SKSpriteNode *dateNumberImgRef;
@property SKSpriteNode *logo1;
@property SKSpriteNode *logo2;
@property SKSpriteNode *logo3;

-(void)digitalCrownScrolledUp;
-(void)digitalCrownScrolledDown;
-(void)nextTheme;
-(void)flyFish;
-(void)toogleShowSeconds;
-(void)toogleUseMasking;
@end

NS_ASSUME_NONNULL_END
