//
//  EditModeTableRowController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 25/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "EditModeTableRowController.h"
#import <SpriteKit/SpriteKit.h>

@interface EditModeTableRowController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@end

@implementation EditModeTableRowController


- (void)setTableRowOption:(FaceTableRowOption *)tableRowOption
{
    _tableRowOption = tableRowOption;
    
    [self.titleLabel setText:_tableRowOption.title];
    
}

@end
