//
//  Theme.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 17/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Types.h"

NS_ASSUME_NONNULL_BEGIN

@interface FaceTheme : NSObject


@property NSString *name;
@property SKColor *bgColor1;
@property SKColor *bgColor2;
@property SKColor *innerColor;
@property SKColor *outerColor;
@property SKColor *hourMinuteColor;
@property SKColor *typefaceColor;
@property SKColor *logoAndDateColor;
@property SKColor *secondsHandColor;
@property (nullable) SKColor *alternateColor;
@property Typeface typeface;
@property DateFontIdentifier dateFontIdentifier;
@property DialStyle dialStyle;
@property BOOL showSeconds;
@property BOOL useMasking;

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
                 showSeconds: (BOOL)showSeconds
                  useMasking: (BOOL)useMasking;
@end

NS_ASSUME_NONNULL_END
