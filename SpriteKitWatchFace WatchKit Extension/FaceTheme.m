//
//  Theme.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 17/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "FaceTheme.h"
#import "HermesPalette.h"

@implementation FaceTheme

@synthesize name, bgColor1, bgColor2, innerColor, outerColor, hourMinuteColor, typefaceColor, logoAndDateColor, secondsHandColor, alternateColor, typeface, dateFontIdentifier, dialStyle, showSeconds, useMasking;


- (instancetype)initWithName: (NSString *)name
                       bgColor1: (SKColor *)bgColor1
                       bgColor2: (SKColor *)bgColor2
                     innerColor: (SKColor *)innerColor
                     outerColor: (SKColor *)outerColor
                hourMinuteColor: (SKColor *)hourMinuteColor
                  typefaceColor: (SKColor *)typefaceColor
               logoAndDateColor: (SKColor *)logoAndDateColor
               secondsHandColor: (SKColor *)secondsHandColor
                 alternateColor: (nullable SKColor *)alternateColor
                       typeface: (Typeface)typeface
              dateFontIdentifier: (DateFontIdentifier)dateFontIdentifier
                      dialStyle: (DialStyle)dialStyle
                    duotoneMode: (DuotoneMode)duotoneMode
                    showSeconds: (bool)showSeconds
                     useMasking: (BOOL)useMasking {
    
    if( [self init]) {
        self.name = name;
        self.bgColor1 = bgColor1;
        self.bgColor2 = bgColor2;
        self.innerColor = innerColor;
        self.outerColor = outerColor;
        self.hourMinuteColor = hourMinuteColor;
        self.typefaceColor = typefaceColor;
        self.logoAndDateColor = logoAndDateColor;
        self.secondsHandColor = secondsHandColor;
        self.alternateColor = alternateColor;
        self.typeface = typeface;
        self.dateFontIdentifier = dateFontIdentifier;
        self.dialStyle = dialStyle;
        self.duotoneMode = duotoneMode;
        self.showSeconds = showSeconds;
        self.useMasking = useMasking;
    }
    
    
    return self;
}


@end
