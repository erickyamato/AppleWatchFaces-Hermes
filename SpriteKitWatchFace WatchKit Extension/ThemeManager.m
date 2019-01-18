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
                       typeface:TypefaceFunnyOutline
                       dateFontIdentifier:DateFontFunny
                       dialStyle:DialStyleAll
                       showSeconds:NO];
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
                        typeface:TypefaceFunnyOutline
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO];
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
                        typeface:TypefaceFunnyOutline
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleAll
                        showSeconds:NO];
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
                        typeface:TypefaceRoman
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleAll
                        showSeconds:YES];
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
                        typeface:TypefaceNormal
                        dateFontIdentifier:DateFontNormal
                        dialStyle:DialStyleCardinal
                        showSeconds:NO];
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
                        hourMinuteColor:blackEleganceTypefaceColor
                        typefaceColor:sportSocialTypefaceColor
                        logoAndDateColor:sportSocialLogoColor
                        secondsHandColor:sportSocialSecondHandColor
                        typeface:TypefaceFunny
                        dateFontIdentifier:DateFontFunny
                        dialStyle:DialStyleCardinal
                        showSeconds:NO];
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



//        case ThemeNavy:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
//            innerColor = colorRegionColor;
//            majorMarkColor = [SKColor whiteColor];
//            minorMarkColor = majorMarkColor;
//            outerColor = [SKColor whiteColor];
//            textColor = [SKColor whiteColor];
//            secondHandColor = majorMarkColor;
//            break;
//        }
//        case ThemeTidepod:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
//            innerColor = [SKColor colorWithRed:0.953 green:0.569 blue:0.196 alpha:1.000];
//            majorMarkColor = [SKColor whiteColor];
//            minorMarkColor = majorMarkColor;
//            outerColor = [SKColor whiteColor];
//            textColor = [SKColor whiteColor];
//            secondHandColor = majorMarkColor;
//            break;
//        }
//        case ThemeBretonnia:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:0.067 green:0.420 blue:0.843 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithRed:0.956 green:0.137 blue:0.294 alpha:1.000];
//            innerColor = faceBackgroundColor;
//            majorMarkColor = [SKColor whiteColor];
//            minorMarkColor = majorMarkColor;
//            outerColor = [SKColor whiteColor];
//            textColor = [SKColor whiteColor];
//            secondHandColor = majorMarkColor;
//            break;
//        }
//
//        case ThemeContrast:
//        {
//
//            colorRegionColor = [SKColor whiteColor];
//            faceBackgroundColor = [SKColor whiteColor];
//            innerColor = [SKColor whiteColor];
//            majorMarkColor = [SKColor blackColor];
//            minorMarkColor = majorMarkColor;
//            outerColor = [SKColor blackColor];
//            textColor = [SKColor blackColor];
//            secondHandColor = majorMarkColor;
//            break;
//        }
//
//        case ThemeRoyal:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1.0];
//            innerColor = colorRegionColor;
//            majorMarkColor = [SKColor colorWithRed:0.318 green:0.388 blue:0.539 alpha:1.000];
//            minorMarkColor = majorMarkColor;
//            outerColor = [SKColor whiteColor];
//            textColor = [SKColor colorWithWhite:0.9 alpha:1];
//            secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
//
//            alternateTextColor = [SKColor colorWithRed:0.218 green:0.288 blue:0.439 alpha:1.000];
//            alternateMinorMarkColor = alternateTextColor;
//            alternateMajorMarkColor = alternateTextColor;
//
//            self.useMasking = YES;
//            break;
//        }
//        case ThemeMarques:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:0.886 green:0.141 blue:0.196 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithRed:0.145 green:0.157 blue:0.176 alpha:1.000];
//            innerColor = colorRegionColor;
//            majorMarkColor = [SKColor colorWithWhite:1 alpha:0.8];
//            minorMarkColor = [faceBackgroundColor colorWithAlphaComponent:0.5];
//            outerColor = [SKColor whiteColor];
//            textColor = [SKColor colorWithWhite:1 alpha:1];
//            secondHandColor = [SKColor colorWithWhite:0.9 alpha:1];
//
//            NSColor *logoAndDateColor = textColor;
//            if (self.useAlternateColorOnLogosAndDate) {
//                logoAndDateColor = [SKColor colorWithRed:0.886 green:0.141 blue:0.196 alpha:1.000];
//            }
//
//            alternateTextColor = logoAndDateColor;
//            alternateMinorMarkColor = [colorRegionColor colorWithAlphaComponent:0.5];
//            alternateMajorMarkColor = [SKColor colorWithWhite:1 alpha:0.8];
//
//            self.useMasking = YES;
//            break;
//        }
//        case ThemeSummer:
//        {
//
//            colorRegionColor = [SKColor colorWithRed:0.969 green:0.796 blue:0.204 alpha:1.000];
//            faceBackgroundColor = [SKColor colorWithRed:0.949 green:0.482 blue:0.188 alpha:1.000];
//            innerColor = faceBackgroundColor;
//            majorMarkColor = [SKColor whiteColor];
//            minorMarkColor = [SKColor colorWithRed:0.267 green:0.278 blue:0.271 alpha:0.3];
//            outerColor = [SKColor colorWithRed:0.467 green:0.478 blue:0.471 alpha:1.000];
//            textColor = [SKColor colorWithRed:0.949 green:0.482 blue:0.188 alpha:1.000];
//            secondHandColor = [SKColor colorWithRed:0.649 green:0.282 blue:0.188 alpha:1.000];
//
//            alternateTextColor = [SKColor whiteColor];
//            alternateMinorMarkColor = minorMarkColor;
//            alternateMajorMarkColor = majorMarkColor;
//
//            self.useMasking = YES;
//            break;
//        }
