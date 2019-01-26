//
//  EditModeTableRowController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 25/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "EditModeTableRowController.h"


@interface EditModeTableRowController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@end

@implementation EditModeTableRowController


- (void)setTableRowOption:(FaceTableRowOption *)tableRowOption
{
    _tableRowOption = tableRowOption;
    
//    [self.iconImageView setImage:_tableRowOption.icon];
    [self.titleLabel setText:_tableRowOption.title];
}

@end
