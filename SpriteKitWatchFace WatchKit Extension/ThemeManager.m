//
//  ThemeManager.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 17/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//
#import "ThemeManager.h"
#import "Types.h"
#import "HermesPalette.h"

@implementation ThemeManager

@synthesize faces, currentFaceIndex;

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentFaceIndex = 0;
        [self buildThemeList];
    }
    return self;
}

- (void)buildThemeList {
    
    faces = [NSMutableArray array];

    for (int i = 0; i < ThemeMAX; i++) {
        
        Theme theme = i;
        FaceTheme *face;
        
        switch (theme) {
            case ThemeHermesRose:
            {
                face = [[FaceTheme alloc]
                       initWithName: @"Rose"
                       bgColor1:roseBg1Color
                       bgColor2:roseBg2Color
                       innerColor:roseHandsInnerColor
                       outerColor:roseHandsOutterColor
                       hourMinuteColor:roseTypefaceColor
                       typefaceColor:roseTypefaceColor
                       logoAndDateColor:roseLogoColor
                       secondsHandColor:roseBg2Color
                       alternateColor: nil
                       typeface:TypefaceFunnyOutline
                       dateFontIdentifier:DateFontFunny
                       dialStyle:DialStyleAll
                       showSeconds:NO
                        useMasking: NO];
                break;
                
            }
            case ThemeHermesOrange:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"Orange"
                        bgColor1:orangeBg1Color
                        bgColor2:orangeBg2Color
                        innerColor:orangeHandsInnerColor
                        outerColor:orangeHandsOutterColor
                        hourMinuteColor:orangeTypefaceColor
                        typefaceColor:orangeTypefaceColor
                        logoAndDateColor:orangeLogoColor
                        secondsHandColor:orangeBg2Color
                        alternateColor: nil
                        typeface:TypefaceFunnyOutline
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO
                        useMasking: NO];
                break;
                
            }
            case ThemeHermesYellowPink:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"YellowPink"
                        bgColor1:yellowPinkBg1Color
                        bgColor2:yellowPinkBg2Color
                        innerColor:yellowPinkHandsInnerColor
                        outerColor:yellowPinkHandsOutterColor
                        hourMinuteColor:yellowPinkTypefaceColor
                        typefaceColor:yellowPinkTypefaceColor
                        logoAndDateColor:yellowPinkLogoColor
                        secondsHandColor:yellowPinkBg2Color
                        alternateColor: nil
                        typeface:TypefaceFunnyOutline
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO
                        useMasking: NO];
                break;
            }
                
            case ThemeHermesBlackElegance:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"Elegance"
                        bgColor1:blackEleganceBg1Color
                        bgColor2:blackEleganceBg2Color
                        innerColor:blackEleganceHandsInnerColor
                        outerColor:blackEleganceHandsOutterColor
                        hourMinuteColor:blackEleganceTypefaceColor
                        typefaceColor:blackEleganceTypefaceColor
                        logoAndDateColor:blackEleganceLogoColor
                        secondsHandColor:blackEleganceSecondHandColor
                        alternateColor: nil
                        typeface:TypefaceRoman
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES
                        useMasking: NO];
                break;
                
            }
            case ThemeHermesBlackOrange:
            {
                
                face = [[FaceTheme alloc]
                        initWithName: @"Social"
                        bgColor1:blackOrangeBg1Color
                        bgColor2:blackOrangeBg2Color
                        innerColor:blackOrangeHandsInnerColor
                        outerColor:blackOrangeHandsOutterColor
                        hourMinuteColor:blackEleganceTypefaceColor
                        typefaceColor:blackOrangeTypefaceColor
                        logoAndDateColor:blackOrangeLogoColor
                        secondsHandColor:blackOrangeSecondHandColor
                        alternateColor: nil
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleCardinal
                        showSeconds:NO
                        useMasking: NO];
                break;
            }
            case ThemeHermesSportSocial:
            {
                
                face = [[FaceTheme alloc]
                        initWithName: @"SportSocial"
                        bgColor1:sportSocialBg1Color
                        bgColor2:sportSocialBg2Color
                        innerColor:sportSocialHandsInnerColor
                        outerColor:sportSocialHandsOutterColor
                        hourMinuteColor:sportSocialTypefaceColor
                        typefaceColor:sportSocialTypefaceColor
                        logoAndDateColor:sportSocialLogoColor
                        secondsHandColor:sportSocialSecondHandColor
                        alternateColor: nil
                        typeface:TypefaceFunny
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleCardinal
                        showSeconds:NO
                        useMasking: NO];
                break;
            }
            case ThemeMarques:
            {
    
                face = [[FaceTheme alloc]
                        initWithName: @"Marques"
                        bgColor1:marquesBg1Color
                        bgColor2:marquesBg2Color
                        innerColor:marquesHandsInnerColor
                        outerColor:marquesHandsOutterColor
                        hourMinuteColor:marquesTypefaceColor
                        typefaceColor:marquesTypefaceColor
                        logoAndDateColor:marquesLogoColor
                        secondsHandColor:marquesSecondHandColor
                        alternateColor: marquesAlternateColor
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES
                        useMasking: YES];
                break;
            }
            case ThemeNavy:
            {
                
                face = [[FaceTheme alloc]
                        initWithName: @"Navy"
                        bgColor1:navyBg1Color
                        bgColor2:navyBg2Color
                        innerColor:navyHandsInnerColor
                        outerColor:navyHandsOutterColor
                        hourMinuteColor:navyTypefaceColor
                        typefaceColor:navyTypefaceColor
                        logoAndDateColor:navyLogoColor
                        secondsHandColor:navySecondHandColor
                        alternateColor: nil
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES
                        useMasking: NO];
                break;
            }
            case ThemeTidepod:
            {
    
                face = [[FaceTheme alloc]
                        initWithName: @"Tidepod"
                        bgColor1:tidepodBg1Color
                        bgColor2:tidepodBg2Color
                        innerColor:tidepodHandsInnerColor
                        outerColor:tidepodHandsOutterColor
                        hourMinuteColor:tidepodTypefaceColor
                        typefaceColor:tidepodTypefaceColor
                        logoAndDateColor:tidepodLogoColor
                        secondsHandColor:tidepodSecondHandColor
                        alternateColor: nil
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES
                        useMasking: NO];
                break;

            }
        
            case ThemeRoyal:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"Royal"
                        bgColor1:royalBg1Color
                        bgColor2:royalBg2Color
                        innerColor:royalHandsInnerColor
                        outerColor:royalHandsOutterColor
                        hourMinuteColor:royalTypefaceColor
                        typefaceColor:royalTypefaceColor
                        logoAndDateColor:royalLogoColor
                        secondsHandColor:royalSecondHandColor
                        alternateColor: royalAlternateColor
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES
                        useMasking: YES];
                break;
                
            }
                
            case ThemePeixeUrbano:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"PeixeUrbano"
                        bgColor1:peixeUrbanoBg1Color
                        bgColor2:peixeUrbanoBg2Color
                        innerColor:peixeUrbanoHandsInnerColor
                        outerColor:peixeUrbanoHandsOutterColor
                        hourMinuteColor:peixeUrbanoTypefaceColor
                        typefaceColor:peixeUrbanoTypefaceColor
                        logoAndDateColor:peixeUrbanoLogoColor
                        secondsHandColor:peixeUrbanoSecondHandColor
                        alternateColor: peixeUrbanoAlternateColor
                        typeface:TypefaceFunnyOutline
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO
                        useMasking: NO];
                break;
                
            }
                
            case ThemePeixeUrbanoLight:
            {
                face = [[FaceTheme alloc]
                        initWithName: @"PeixeUrbano Light"
                        bgColor1:peixeUrbanoLightBg1Color
                        bgColor2:peixeUrbanoLightBg2Color
                        innerColor:peixeUrbanoLightHandsInnerColor
                        outerColor:peixeUrbanoLightHandsOutterColor
                        hourMinuteColor:peixeUrbanoLightTypefaceColor
                        typefaceColor:peixeUrbanoLightTypefaceColor
                        logoAndDateColor:peixeUrbanoLightLogoColor
                        secondsHandColor:peixeUrbanoLightSecondHandColor
                        alternateColor: peixeUrbanoLightAlternateColor
                        typeface:TypefaceFunny
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO
                        useMasking: YES];
                break;
                
            }
                
            default: {}
        }
        
        if (face != nil) {
            [faces addObject:face];
        }
    }
}

- (void) resetAllFaces {
    [self buildThemeList];
}

- (FaceTheme *)currentTheme {
    return faces[currentFaceIndex];
}

@end
