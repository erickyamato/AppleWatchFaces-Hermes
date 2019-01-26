//
//  EditModeTableRowController.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 25/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceTableRowOption.h"
@import WatchKit;

NS_ASSUME_NONNULL_BEGIN

@interface EditModeTableRowController : NSObject
@property (nonatomic, strong) FaceTableRowOption *tableRowOption;



@end

NS_ASSUME_NONNULL_END
