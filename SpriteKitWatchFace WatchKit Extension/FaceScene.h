//
//  FaceScene.h
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	ThemeHermesPink,
	ThemeHermesOrange,
	ThemeNavy,
	ThemeTidepod,
	ThemeBretonnia,
	ThemeNoir,
	ThemeContrast,
	ThemeVictoire,
	ThemeLiquid,
	ThemeAngler,
	ThemeSculley,
	ThemeKitty,
	ThemeDelay,
	ThemeDiesel,
	ThemeLuxe,
	ThemeSage,
	ThemeBondi,
	ThemeTangerine,
	ThemeStrawberry,
	ThemePawn,
	ThemeRoyal,
	ThemeMarques,
	ThemeVox,
	ThemeSummer,
	ThemeMAX
} Theme;

typedef enum : NSUInteger {
    NumeralStyleNone,
    NumeralStyleAll,
    NumeralStyleCardinal,
	NumeralStyleTweoveOnTop
} NumeralStyle;


typedef enum : NSUInteger {
	ColorRegionStyleNone,
	ColorRegionStyleDynamicDuo,
	ColorRegionStyleHalf,
	ColorRegionStyleCircle,
	ColorRegionStyleRing,
	ColorRegionStyleMAX
} ColorRegionStyle;


@interface FaceScene : SKScene <SKSceneDelegate>

-(void)refreshTheme;

@property Theme theme;
@property NumeralStyle numeralStyle;
@property ColorRegionStyle colorRegionStyle;

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


@property BOOL romanNumerals;


@property BOOL styleHalfShouldBeVertical; //good for masking tests
@property BOOL useAlternateColorOnLogosAndDate;

@property CGSize faceSize;
@property SKSpriteNode *dateNumberImgRef;
@property SKSpriteNode *logo1;
@property SKSpriteNode *logo2;
@property SKSpriteNode *logo3;


@end





NS_ASSUME_NONNULL_END
