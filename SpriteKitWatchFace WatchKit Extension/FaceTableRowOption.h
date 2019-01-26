//
//  FaceTableRowOption.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 25/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EditOption) {
    EditModeTypefaceOption,
    EditModeUseMaskingOption,
    EditModeShowSecondsOption,
    ResetStyles
};

NS_ASSUME_NONNULL_BEGIN

@interface FaceTableRowOption : NSObject


//+ (instancetype __nonnull)optionWithNanoOption:(EditOption)opt;

@property (nonatomic, assign) EditOption option;

@property (readonly) NSString *__nonnull title;

+ (NSString *__nonnull)titleForOption:(EditOption)option;
+ (instancetype __nonnull)optionWithNanoOption:(EditOption)opt;

@end

NS_ASSUME_NONNULL_END
