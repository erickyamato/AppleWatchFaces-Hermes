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
    DialStyleNone,
    DialStyleAll,
    DialStyleCardinal,
    DialStyleTweoveOnTop
} DialStyle;


typedef enum : NSUInteger {
    ColorRegionStyleNone,
    ColorRegionStyleDynamicDuo,
    ColorRegionStyleHalf
} ColorRegionStyle;

typedef enum : NSUInteger {
    TypefaceNormal,
    TypefaceTech,
    TypefaceFunny,
    TypefaceFunnyOutline,
    TypefaceRoman,
    TypefaceMAX
} Typeface;

#endif /* Types_h */
