//
//  FaceTableRowOption.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 25/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "FaceTableRowOption.h"

NSDictionary <NSNumber *, NSString *> *kNanoRowOptionToTitleMapping;

@implementation FaceTableRowOption

+ (NSDictionary <NSNumber *, NSString *> *)_optionToTitleMapping
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kNanoRowOptionToTitleMapping = @{
                                         @(EditModeTypefaceOption): @"Typeface",
                                         @(EditModeUseMaskingOption): @"Masking on/off",
                                         @(EditModeShowSecondsOption): @"Seconds show/hide",
                                         @(ResetStyles): @"Reset all faces",
                                         };
    });
    
    return kNanoRowOptionToTitleMapping;
}

- (NSString *)title
{
    return [FaceTableRowOption titleForOption:_option];
}

+ (NSString *)titleForOption:(EditOption)option
{
    return [[FaceTableRowOption _optionToTitleMapping] objectForKey:@(option)];
}

+ (instancetype __nonnull)optionWithNanoOption:(EditOption)opt
{
    FaceTableRowOption *rowOption = [FaceTableRowOption new];
    
    rowOption.option = opt;
    
    return rowOption;
}

@end
