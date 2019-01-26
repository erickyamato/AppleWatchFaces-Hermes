//
//  GeneralSettingsInterfaceController.h
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 21/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "FaceScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface GeneralSettingsInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property IBOutlet FaceScene * scene;

@end

NS_ASSUME_NONNULL_END
