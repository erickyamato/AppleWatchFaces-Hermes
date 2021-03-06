//
//  GeneralSettingsInterfaceController.m
//  SpriteKitWatchFace WatchKit Extension
//
//  Created by Daniel Bonates on 21/01/19.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "GeneralSettingsInterfaceController.h"
#import "FaceScene.h"
#import "EditModeTableRowController.h"

NSString * const kOptionTableRowIdentifier = @"OptionTableRow";

@interface GeneralSettingsInterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property (nonatomic, copy) NSArray <NSNumber *> *options;

@end

@implementation GeneralSettingsInterfaceController

@synthesize scene;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
        
    self.options = @[
                     @(EditModeDialStyleOption),
                     @(EditModeTypefaceOption),
                     @(EditModeDuotoneStyleOption),
                     @(EditModeUseMaskingOption),
                     @(EditModeShowSecondsOption),
                     @(ResetStyles),
                     @(ResetCurrentFace)
                     ];
    
    
    NSDictionary *dict = (NSDictionary *)context;
    
    if (dict != nil) {
        FaceScene *s = (FaceScene *)[dict objectForKey:@"scene"];
        self.scene = s;
    }
    
}


- (void)setOptions:(NSArray<NSNumber *> *)options
{
    _options = [options copy];
    
    [self _configureTable];
}

- (void)_configureTable
{
    
    [self.table setRowTypes:@[kOptionTableRowIdentifier]];
    [self.table setNumberOfRows:self.options.count withRowType:kOptionTableRowIdentifier];

    for (NSUInteger i = 0; i < self.table.numberOfRows; i++) {
        EditOption opt = self.options[i].unsignedIntegerValue;
        EditModeTableRowController *row = [self.table rowControllerAtIndex:i];
        row.tableRowOption = [FaceTableRowOption optionWithNanoOption:opt];
    }
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    [self performActionForOption:self.options[rowIndex].unsignedIntegerValue];
}


- (void)performActionForOption:(EditOption)option
{
    switch (option) {
        case EditModeDialStyleOption:
            [scene setCrownEditMode: EditModeDialStyle];
            [self dismissController];
            break;
        case EditModeTypefaceOption:
            [scene setCrownEditMode: EditModeTypeface];
            [self dismissController];
            break;
        case EditModeDuotoneStyleOption:
            [scene setCrownEditMode: EditModeDuotoneStyle];
            [self dismissController];
            break;
        case EditModeShowSecondsOption:
            [scene setCrownEditMode: EditModeShowSeconds];
            [self dismissController];
            break;
        case EditModeUseMaskingOption:
            [scene setCrownEditMode: EditModeUseMasking];
            [self dismissController];
            break;
        case ResetStyles:
            [self askForResetStyles];
            break;
        case ResetCurrentFace:
            [self askForResetCurrentFaceStyle];
            break;
        default:
            break;
    }
}

- (void)resetStyles {
    [scene resetStyles];
    
    // should be outside WKAlertAction handler
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self dismissController];
        
    });
    
}
- (void)askForResetStyles {
    
    [self presentAlertControllerWithTitle: @"Alert!" message:@"Reset faces to their default styles?" preferredStyle: WKAlertControllerStyleActionSheet actions: @[ [WKAlertAction actionWithTitle: @"YES" style: WKAlertActionStyleDestructive handler:^{
        [self resetStyles];
    }], [WKAlertAction actionWithTitle: @"NO" style: WKAlertActionStyleCancel handler:^{
        NSLog(@"Canceled");
    }]]];
    
}


- (void)resetCurrentFaceStyle {
    [scene resetCurrentFaceStyle];
    
    // should be outside WKAlertAction handler
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self dismissController];
        
    });
    
}
- (void)askForResetCurrentFaceStyle {
    
    [self presentAlertControllerWithTitle: @"Alert!" message:@"Reset current face to it's default style?" preferredStyle: WKAlertControllerStyleActionSheet actions: @[ [WKAlertAction actionWithTitle: @"YES" style: WKAlertActionStyleDestructive handler:^{
        [self resetCurrentFaceStyle];
    }], [WKAlertAction actionWithTitle: @"NO" style: WKAlertActionStyleCancel handler:^{
        NSLog(@"Canceled");
    }]]];
    
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}
- (IBAction)closeTapped {
    
    FaceScene *scene = [FaceScene nodeWithFileNamed:@"FaceScene"];
    scene.crownEditMode = EditModeFace;
//    scene.changingFace = NO;
    [scene nextTheme];
    [self dismissController];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



