//
//  ThemeManager.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 17/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

@property NSMutableArray *faces;

@property int currentFaceIndex;

+ (id)sharedInstance;

- (void)buildThemeList;

- (void) resetAllFaces;
- (void) resetCurrentFace;

- (FaceTheme *)currentTheme;

@end

NS_ASSUME_NONNULL_END
