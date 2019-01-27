//
//  Types.h
//  SpriteKitWatchFace
//
//  Created by Daniel Bonates on 15/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#ifndef Types_h
#define Types_h

typedef enum : NSUInteger {
    ThemeHermesRose,
    ThemeHermesOrange,
    ThemeHermesYellowPink,
    ThemeHermesBlackElegance,
    ThemeHermesBlackOrange,
    ThemeHermesSportSocial,
    // PU
    ThemePeixeUrbano,
    ThemePeixeUrbanoLight,
    // Non Hermès
    ThemeMarques,
    ThemeNavy,
    ThemeTidepod,
    ThemeRoyal,
    //
    ThemeMAX
} Theme;

typedef enum : NSUInteger {
    DialStyleNone,
    DialStyleAll,
    DialStyleCardinal,
    DialStyleTweoveOnTop,
    DialStyleMAX
} DialStyle;


typedef enum : NSUInteger {
    DuotoneModeNone,
    DuotoneModeDynamic,
    DuotoneModeHorizontal,
    DuotoneModeVertical,
    DuotoneModeAngular,
    DuotoneModeMAX,
} DuotoneMode;

typedef enum : NSUInteger {
    TypefaceNormal,
    TypefaceTech,
    TypefaceFunny,
    TypefaceFunnyOutline,
    TypefaceRoman,
    TypefaceMAX
} Typeface;


typedef enum : NSUInteger {
    DateFontNormal,
    DateFontFunny
} DateFontIdentifier;


typedef enum : NSUInteger {
    EditModeFace,
    EditModeTypeface,
    EditModeDialStyle,
    EditModeNone,
    EditModeShowSeconds,
    EditModeUseMasking,
    EditModeDuotoneStyle,
    EditModeMax
} EditMode;

#endif /* Types_h */
