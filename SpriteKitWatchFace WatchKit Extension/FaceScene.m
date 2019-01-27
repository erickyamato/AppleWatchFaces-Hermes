//
//  FaceScene.m
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "FaceScene.h"
#import "HermesPalette.h"
#import "ThemeManager.h"
#import <WatchKit/WatchKit.h>

@import CoreText;

#if TARGET_OS_IPHONE

/* Sigh. */

#define NSImage UIImage
#define NSColor UIColor

#define NSFont UIFont
#define NSFontWeightMedium UIFontWeightMedium

#define NSFontFeatureTypeIdentifierKey UIFontFeatureTypeIdentifierKey
#define NSFontFeatureSettingsAttribute UIFontDescriptorFeatureSettingsAttribute
#define NSFontDescriptor UIFontDescriptor

#define NSFontFeatureSelectorIdentifierKey UIFontFeatureSelectorIdentifierKey
#define NSFontNameAttribute UIFontDescriptorNameAttribute

#endif

#define PREPARE_SCREENSHOT 0




@interface FaceScene()


@property (nonatomic, retain) ThemeManager *tm;


@end

@implementation FaceScene

@synthesize logo1, logo2, logo3, bgColor1, bgColor2, hourMinuteColor, secondsHandColor, innerColor, outerColor, typefaceColor, logoAndDateColor, showSeconds, dateFontIdentifier, crownEditMode, tm;

BOOL crownEventRunning = NO;

CGFloat regionTransitionDuration = 0.2;
SKSpriteNode *logoSprite;

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
        self.tm = [ThemeManager sharedInstance];
        
		self.faceSize = (CGSize){184, 224};
        
        self.useAlternateColorOnLogosAndDate = YES;
        
        self.updatingTypeFace = YES;
        
        self.dateFontIdentifier = DateFontNormal;
        
        showSeconds = YES;
        
        crownEditMode = EditModeNone;
        
        int themeIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"Theme"];
        
        if (themeIndex >=  [tm faces].count) {
            themeIndex = 0;
        }
        
        [tm setCurrentFaceIndex: themeIndex]; //ThemeHermesBlackOrange; //
        
		[self refreshTheme];
		
		self.delegate = self;
        
	}
	return self;
}


#pragma mark -


-(void)setupTickmarksForRectangularFaceWithLayerName:(NSString *)layerName
{

	CGFloat labelYMargin = 20.0;
	CGFloat labelXMargin = 14.0;
	
	SKCropNode *faceMarkings = [SKCropNode node];
	faceMarkings.name = layerName;
    
    BOOL isAlternateLayer = [layerName isEqualToString:@"Markings Alternate"] ? YES : NO;
	
	/* Numerals */
    
    FaceTheme *theme = [tm currentTheme];

    if (theme.dialStyle == DialStyleTweoveOnTop) { //12 only
        
        CGFloat fontSize = 25;
        
        SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
        labelNode.anchorPoint = CGPointMake(0.5,0.5);
        
        labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + ((12+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, self.faceSize.height/2-labelYMargin);
        
        [faceMarkings addChild:labelNode];
        
        SKSpriteNode *numberImg = [SKSpriteNode spriteNodeWithTexture: [self textureForNumeral: 12]];
        numberImg.color = isAlternateLayer ? theme.alternateColor : theme.typefaceColor;
        numberImg.colorBlendFactor = 1.0;
        numberImg.xScale = 1;
        numberImg.yScale = 1;
        numberImg.alpha = self.updatingTypeFace ? 0 : 1;
        
        [labelNode addChild: numberImg];
        
        if (self.updatingTypeFace) {
            [numberImg runAction: [SKAction fadeInWithDuration: 0.2]];
        }
        
        
    } else if (theme.dialStyle == DialStyleCardinal || theme.dialStyle == DialStyleAll) {
    
        NSMutableArray *allNumbers = [NSMutableArray array];
        
        for (int i = 1; i <= 12; i++)
        {
            CGFloat fontSize = 25;

            SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
            labelNode.anchorPoint = CGPointMake(0.5,0.5);

            if (i == 1 || i == 11 || i == 12)
                labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + ((i+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, self.faceSize.height/2-labelYMargin);
            else if (i == 5 || i == 6 || i == 7)
                labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + (2-((i+1)%3)) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, -self.faceSize.height/2+labelYMargin);
            else if (i == 2 || i == 3 || i == 4)
                labelNode.position = CGPointMake(self.faceSize.height/2-fontSize-labelXMargin, -(self.faceSize.width-labelXMargin*2)/2 + (2-((i+1)%3)) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelYMargin*2)/6.0);
            else if (i == 8 || i == 9 || i == 10)
                labelNode.position = CGPointMake(-self.faceSize.height/2+fontSize+labelXMargin, -(self.faceSize.width-labelXMargin*2)/2 + ((i+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelYMargin*2)/6.0);

            [faceMarkings addChild:labelNode];


            SKSpriteNode *numberImg = [SKSpriteNode spriteNodeWithTexture: [self textureForNumeral: i]];
            numberImg.color = isAlternateLayer ? theme.alternateColor : theme.typefaceColor;
            numberImg.colorBlendFactor = 1.0;
            numberImg.xScale = 0.9;
            numberImg.yScale = 0.9;
            numberImg.alpha = self.updatingTypeFace ? 0 : 1.0;
            
            if (theme.dialStyle == DialStyleAll) {

                [labelNode addChild: numberImg];
                [allNumbers addObject:numberImg];
                
            } else if (theme.dialStyle == DialStyleCardinal && (i % 3 == 0)) {
                
                [labelNode addChild: numberImg];
                [allNumbers addObject:numberImg];
                
            } else if (i == 12 && theme.dialStyle == DialStyleTweoveOnTop) {
                
                [labelNode addChild: numberImg];
                [allNumbers addObject:numberImg];
            }

        }
        
        if (self.updatingTypeFace) {
            NSMutableArray *actions = [NSMutableArray array];
            
            for (int i = 0; i < allNumbers.count; i++)
            {
                [actions addObject: [SKAction waitForDuration: 0.05 * i]];
                [actions addObject: [SKAction fadeInWithDuration: 0.2]];
                
                [[allNumbers objectAtIndex: i] runAction: [SKAction sequence: actions]];
                
                [actions removeAllObjects];
            }
            
        }
    
    
    }
    
    
    if ([theme.name isEqualToString: @"PeixeUrbano"] || [theme.name isEqualToString: @"PeixeUrbano Light"]) {
        
        SKTexture *logo1Texture = [SKTexture textureWithImage: isAlternateLayer ? [NSImage imageNamed: @"pu_logo_white"] : [NSImage imageNamed: @"pu_logo"]];
        SKSpriteNode *logo1Img = [SKSpriteNode spriteNodeWithTexture: logo1Texture];
        [faceMarkings addChild:logo1Img];
        logo1Img.name = @"PU_LOGO";
        logo1Img.xScale = 1.2;
        logo1Img.yScale = 1.2;
        logo1Img.position = CGPointMake(4, (self.faceSize.height / 2) - (labelYMargin + 40));
        
        logo1 = logo1Img;
        
    } else {
        SKTexture *logo1Texture = [SKTexture textureWithImage: [NSImage imageNamed: @"ZeusLogo1-394h"]];
        SKSpriteNode *logo1Img = [SKSpriteNode spriteNodeWithTexture: logo1Texture];
        [faceMarkings addChild:logo1Img];
        logo1Img.color = isAlternateLayer ? theme.alternateColor : theme.logoAndDateColor;
        logo1Img.colorBlendFactor = 1.0;
        logo1Img.xScale = 1.2;
        logo1Img.yScale = 1.2;
        logo1Img.position = CGPointMake(0, (self.faceSize.height / 2) - (labelYMargin + 25));
        
        
        SKTexture *logo2Texture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusLogo2-394h"]];
        SKSpriteNode *logo2Img = [SKSpriteNode spriteNodeWithTexture: logo2Texture];
        [faceMarkings addChild:logo2Img];
        logo2Img.color = isAlternateLayer ? theme.alternateColor : theme.logoAndDateColor;
        logo2Img.colorBlendFactor = 1.0;
        logo2Img.xScale = 1.2;
        logo2Img.yScale = 1.2;
        logo2Img.position = CGPointMake(logo1Img.position.x, (logo1Img.position.y - 11));
        
        SKTexture *moonTexture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusMoon_0088-regular"]];
        SKSpriteNode *moonImg = [SKSpriteNode spriteNodeWithTexture: moonTexture];
        [faceMarkings addChild:moonImg];
        moonImg.color = isAlternateLayer ? theme.alternateColor : theme.logoAndDateColor;
        moonImg.colorBlendFactor = 1.0;
        moonImg.position = CGPointMake(logo2Img.position.x, (logo1Img.position.y - 27));
    }
    
    if (theme.dialStyle != DialStyleNone) {
        
        SKSpriteNode *dayImg = [SKSpriteNode spriteNodeWithTexture: [self textureForToday]];
        [faceMarkings addChild:dayImg];
        dayImg.color = isAlternateLayer ? theme.alternateColor : theme.logoAndDateColor;
        dayImg.colorBlendFactor = 1.0;
        dayImg.position = CGPointMake(0, -(self.faceSize.height / 2) + (labelYMargin + 40));
    }
	
	[self addChild:faceMarkings];
    
    
    if (!isAlternateLayer && crownEventRunning) {
        
        NSDictionary *attribs = @{NSFontAttributeName : [NSFont fontWithName:@"Futura-Medium" size:12], NSForegroundColorAttributeName : theme.typefaceColor, NSBackgroundColorAttributeName : theme.bgColor1};
    
        NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:tm.currentTheme.name.uppercaseString attributes:attribs];
    
        SKLabelNode *numberLabel = [SKLabelNode labelNodeWithAttributedText:labelText];
        numberLabel.zPosition = 1000;
        numberLabel.position = CGPointMake(0, -numberLabel.frame.size.height/2);
        numberLabel.alpha = 0;
    
        [self addChild:numberLabel];
    
        [self fadeAndRemove: numberLabel runningCrownEvent: crownEventRunning];
    }
}

- (void)fadeAndRemove:(SKNode *)node runningCrownEvent: (BOOL)runningCrownEvent {
    SKAction *fadeIn = [SKAction fadeInWithDuration: 0.2];
    SKAction *delay = [SKAction waitForDuration: 0.7];
    SKAction *fadeOut = [SKAction fadeOutWithDuration: 0.2];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence: @[fadeIn, delay, fadeOut, remove]];
    
    [node runAction: sequence completion:^{
        if (runningCrownEvent)
            [self crownFiredEventUnlock];
    }];
    
}

- (void)crownFiredEventUnlock {
    crownEventRunning = NO;
}

- (SKTexture *)textureForNumeral: (int)number {
    
    NSString *imgName = @"";

    switch ([tm currentTheme].typeface) {
            
        case TypefaceNormal:
            
            imgName =  [NSString stringWithFormat: @"ZeusFont_2_%d-394h", number];
            break;
            
        case TypefaceTech:
            imgName =  [NSString stringWithFormat: @"ZeusFont_4_%d-394h", number];
            break;
            
        case TypefaceFunny:
            imgName =  [NSString stringWithFormat: @"ZeusFont_3_%d-394h", number];
            break;
        
        case TypefaceFunnyOutline:
            imgName =  [NSString stringWithFormat: @"ZeusFont_3_outline_%d-394h", number];
            break;
            
        case TypefaceRoman:
            imgName =  [NSString stringWithFormat: @"ZeusFont_5_%d-394h", number];
            break;
            
        default:
            break;
    }
    
    return [SKTexture textureWithImage:[NSImage imageNamed: imgName]];
}


- (SKTexture *)textureForToday {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    
    NSString *dayString = day < 10 ? [NSString stringWithFormat:@"0%d", day] : [NSString stringWithFormat: @"%d", day];
    
    NSString *finalDayString = [NSString stringWithFormat: @"ZeusDate-%@-%@-394h", [self dateFontIdentifierForCurrentTheme], dayString];
    
    SKTexture *numberImage = [SKTexture textureWithImage:[NSImage imageNamed: finalDayString]];
    
    return numberImage;
}

- (NSString *)dateFontIdentifierForCurrentTheme {
    FaceTheme *theme = [tm currentTheme];
    return theme.dateFontIdentifier == DateFontNormal ? @"5" : @"3";
}

#pragma mark -


-(void)setupColors
{
	SKColor *alternateTextColor = nil;

	self.useMasking = NO;


	self.alternateTextColor = alternateTextColor;
    
}


-(void)setupScene
{
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKSpriteNode *hourHand = (SKSpriteNode *)[face childNodeWithName:@"Hours"];
	SKSpriteNode *minuteHand = (SKSpriteNode *)[face childNodeWithName:@"Minutes"];
	
	SKSpriteNode *hourHandInlay = (SKSpriteNode *)[hourHand childNodeWithName:@"Hours Inlay"];
	SKSpriteNode *minuteHandInlay = (SKSpriteNode *)[minuteHand childNodeWithName:@"Minutes Inlay"];
	
	SKSpriteNode *secondHand = (SKSpriteNode *)[face childNodeWithName:@"Seconds"];
	SKSpriteNode *colorRegion = (SKSpriteNode *)[face childNodeWithName:@"Color Region"];
	SKSpriteNode *colorRegionReflection = (SKSpriteNode *)[face childNodeWithName:@"Color Region Reflection"];
	SKSpriteNode *numbers = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];
    
    
    self.datePlaceHolder = (SKSpriteNode *)[face childNodeWithName:@"Date Number"];
    
    FaceTheme *theme = [tm currentTheme];
    
    [hourHand runAction: [SKAction colorizeWithColor: theme.outerColor colorBlendFactor: 1 duration: regionTransitionDuration]];

    [hourHandInlay runAction: [SKAction colorizeWithColor: theme.innerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	[minuteHand runAction: [SKAction colorizeWithColor: theme.outerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
    
    [minuteHandInlay runAction: [SKAction colorizeWithColor: theme.innerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
    [secondHand runAction: [SKAction colorizeWithColor: theme.secondsHandColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
    [self runAction: [SKAction colorizeWithColor: theme.bgColor2 colorBlendFactor: 1 duration: regionTransitionDuration]];
    
    if (tm.currentTheme.duotoneMode == DuotoneModeNone)
    {
        [colorRegion runAction: [SKAction colorizeWithColor: theme.bgColor2 colorBlendFactor: 1 duration: regionTransitionDuration]];
    } else {
        [colorRegion runAction: [SKAction colorizeWithColor: theme.bgColor1 colorBlendFactor: 1 duration: regionTransitionDuration]];
    }
	
	numbers.color = theme.typefaceColor;
	numbers.colorBlendFactor = 1.0;
	

    secondHand.color = theme.secondsHandColor;
    secondHand.colorBlendFactor = 1.0;
		
	if (tm.currentTheme.duotoneMode == DuotoneModeDynamic)
	{
		colorRegion.alpha = 1.0;
		colorRegion.texture = nil;
		colorRegion.anchorPoint = CGPointMake(0.5, 0);
		colorRegion.size = CGSizeMake(768, 768);

		colorRegionReflection.texture = nil;

	}
	else
	{
		colorRegion.alpha = 1.0;
		colorRegion.texture = nil;
		colorRegion.anchorPoint = CGPointMake(0.5, 0);
		colorRegion.size = CGSizeMake(768, 768);

		colorRegionReflection.texture = nil;

	}
	
    SKSpriteNode *numbersLayer = (SKSpriteNode *)[face childNodeWithName:@"Numbers"];

        numbersLayer.alpha = 0;
        [self setupTickmarksForRectangularFaceWithLayerName:@"Markings"];

    colorRegionReflection.alpha = 0;
}


-(void)setupMasking
{
	SKCropNode *faceMarkings = (SKCropNode *)[self childNodeWithName:@"Markings"];
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];
	SKNode *colorRegionReflection = [face childNodeWithName:@"Color Region Reflection"];
	
	faceMarkings.maskNode = colorRegion;
		
	[self setupTickmarksForRectangularFaceWithLayerName:@"Markings Alternate"];
	
	SKCropNode *alternateFaceMarkings = (SKCropNode *)[self childNodeWithName:@"Markings Alternate"];
    colorRegionReflection.alpha = 1;
    
	alternateFaceMarkings.maskNode = colorRegionReflection;
}

#pragma mark -

- (void)update:(NSTimeInterval)currentTime forScene:(SKScene *)scene
{
	[self updateHands];
}
 CGFloat testRotation = -1.8;


-(void)flyFish {
    
    
    NSLog(@"start!");

    
}


-(void)updateHands
{
   
#if PREPARE_SCREENSHOT
	NSDate *now = [NSDate dateWithTimeIntervalSince1970:32760+27]; // 10:06:27am
#else
	NSDate *now = [NSDate date];
#endif
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond| NSCalendarUnitNanosecond) fromDate:now];
	
	SKNode *face = [self childNodeWithName:@"Face"];
	
	SKNode *hourHand = [face childNodeWithName:@"Hours"];
	SKNode *minuteHand = [face childNodeWithName:@"Minutes"];
	SKNode *secondHand = [face childNodeWithName:@"Seconds"];
    
    FaceTheme *theme = [tm currentTheme];
    secondHand.alpha = theme.showSeconds ? 1.0 : 0;
    
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];
	SKNode *colorRegionReflection = [face childNodeWithName:@"Color Region Reflection"];

	hourHand.zRotation =  - (2*M_PI)/12.0 * (CGFloat)(components.hour%12 + 1.0/60.0*components.minute);
	minuteHand.zRotation =  - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	secondHand.zRotation = - (2*M_PI)/60 * (CGFloat)(components.second + 1.0/NSEC_PER_SEC*components.nanosecond);
    
    if (tm.currentTheme.duotoneMode == DuotoneModeAngular) {
        colorRegion.alpha = 1.0;
        
        CGFloat desiredRotation = M_PI_2 / 2;
        
        SKAction *rotation = [SKAction rotateToAngle:desiredRotation duration:0.15 shortestUnitArc:YES];
        
        [colorRegionReflection runAction: rotation];
        [colorRegion runAction: rotation];
    }
	else if (tm.currentTheme.duotoneMode == DuotoneModeDynamic)
	{
        [colorRegion runAction: [SKAction fadeInWithDuration:0.20]];
        
        CGFloat regionDesiredRotation = M_PI_2 -(2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
        
        [colorRegion runAction: [SKAction rotateToAngle:regionDesiredRotation duration:0.2 shortestUnitArc:YES]];
        
         CGFloat reflectionDesiredRotation = M_PI_2 - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
        
        [colorRegionReflection runAction: [SKAction rotateToAngle:reflectionDesiredRotation duration:0.2 shortestUnitArc:YES]];
	}
	else if (tm.currentTheme.duotoneMode == DuotoneModeHorizontal)
	{
		colorRegion.alpha = 1.0;

        CGFloat desiredRotation = 0;
        
        SKAction *rotation = [SKAction rotateToAngle:desiredRotation duration:0.15 shortestUnitArc:YES];
        
        [colorRegionReflection runAction: rotation];
        [colorRegion runAction: rotation];
        
    } else if (tm.currentTheme.duotoneMode == DuotoneModeVertical) {
        
        colorRegion.alpha = 1.0;
        
        CGFloat desiredRotation = M_PI_2;
        
        SKAction *rotation = [SKAction rotateToAngle:desiredRotation duration:0.15 shortestUnitArc:YES];
        
        [colorRegionReflection runAction: rotation];
        [colorRegion runAction: rotation];
        
    }
    else {} // solid color
    
}

- (void)changeEditModeTo:(EditMode)editMode {
    crownEditMode = editMode;
    NSLog(@"editMode: %d", crownEditMode);
}

-(void)digitalCrownScrolledUp {
    
    if (crownEventRunning) { return; }
    
    
    switch (crownEditMode) {
        case EditModeFace:
            
            [self activateCrownEvent];
            [self nextTheme];
            
            break;
            
        case EditModeTypeface:
            
            [self activateCrownEvent];
            [self nextTypeface];
            
            break;
            
        case EditModeDialStyle:
            
            [self activateCrownEvent];
            [self nextColorDialStyle];
            
            break;
            
        case EditModeShowSeconds:
            
            [self activateCrownEvent];
            [self toogleShowSeconds];
            
            break;
            
        case EditModeUseMasking:
            
            [self activateCrownEvent];
            [self toogleUseMasking];
            
            break;
            
        case EditModeDuotoneStyle:
            
            [self activateCrownEvent];
            [self nextDuotoneMode];
            
            break;
            
        default:
            break;
    }
    
}

-(void)activateCrownEvent {
    crownEventRunning = YES;
    [[WKInterfaceDevice currentDevice] playHaptic: WKHapticTypeStart];
}

-(void)digitalCrownScrolledDown {
    
    
    if (crownEventRunning) { return; }
    
    switch (crownEditMode) {
        case EditModeFace:

            [self activateCrownEvent];
            [self previousTheme];
            
            break;
            
        case EditModeTypeface:

            [self activateCrownEvent];
            [self previousTypeface];

            break;
            
        case EditModeDialStyle:

            [self activateCrownEvent];
            [self previousColorDialStyle];

            break;
            
        case EditModeShowSeconds:
            
            [self activateCrownEvent];
            [self toogleShowSeconds];

            break;
            
        case EditModeUseMasking:
            
            [self activateCrownEvent];
            [self toogleUseMasking];
            
            break;
            
        case EditModeDuotoneStyle:
            
            [self activateCrownEvent];
            [self previousDuotoneMode];
            
            break;
            
        default:
            break;
    }
    
    
}

-(void)toogleUseMasking {
    tm.currentTheme.useMasking = !tm.currentTheme.useMasking;
    [self refreshTheme];
}

-(void)toogleShowSeconds {
    tm.currentTheme.showSeconds = !tm.currentTheme.showSeconds;
    [self refreshTheme];
}

-(void)resetStyles {
    [tm buildThemeList];
    crownEditMode = EditModeNone;
    [[WKInterfaceDevice currentDevice] playHaptic: WKHapticTypeStart];
    [self refreshTheme];
}

-(void)resetCurrentFaceStyle {
    [tm resetCurrentFace];
    crownEditMode = EditModeNone;
    [[WKInterfaceDevice currentDevice] playHaptic: WKHapticTypeStart];
    [self refreshTheme];
}

-(void)nextTheme {
    
    
    
    int themeId = tm.currentFaceIndex;
    themeId++;
    if (themeId >= ThemeMAX) {
        tm.currentFaceIndex = 0;
    } else {
        tm.currentFaceIndex = themeId;
    }
    
    [self refreshTheme];
}

-(void)previousTheme {
    
    
    int themeId = tm.currentFaceIndex;
    themeId--;
    if (themeId < 0) {
        tm.currentFaceIndex = ThemeMAX - 1;
    } else {
        tm.currentFaceIndex = themeId;
    }
    
    [self refreshTheme];
}

-(void)nextTypeface {
    
    Typeface currentTypeface = tm.currentTheme.typeface;
    
    if (currentTypeface == TypefaceRoman) {
        currentTypeface = 0;
    } else {
        currentTypeface++;
    }
    
    tm.currentTheme.typeface = currentTypeface;
    
    [self refreshTheme];
}

-(void)previousTypeface {
    
    Typeface currentTypeface = tm.currentTheme.typeface;
    
    if (currentTypeface == TypefaceNormal) {
        currentTypeface = TypefaceRoman;
    } else {
        --currentTypeface;
    }
    
    tm.currentTheme.typeface = currentTypeface;
    
    [self refreshTheme];
    
}

-(void)nextColorDialStyle {
    
    DialStyle dialStyle = tm.currentTheme.dialStyle;
    
    if (dialStyle == DialStyleTweoveOnTop) {
        dialStyle = 0;
    } else {
        dialStyle++;
    }
    tm.currentTheme.dialStyle = dialStyle;
    
     [self refreshTheme];
}


-(void)previousColorDialStyle {
    
    DialStyle dialStyle = tm.currentTheme.dialStyle;
    
    if (dialStyle == DialStyleNone) {
        dialStyle = DialStyleTweoveOnTop;
    } else {
        --dialStyle;
    }
    
    tm.currentTheme.dialStyle = dialStyle;
    
    [self refreshTheme];
}


-(void)nextDuotoneMode {
    
    DuotoneMode dtMode = tm.currentTheme.duotoneMode;
    
    if (dtMode == DuotoneModeAngular) {
        dtMode = 0;
    } else {
        dtMode++;
    }
    tm.currentTheme.duotoneMode = dtMode;
    
    [self refreshTheme];
}


-(void)previousDuotoneMode {
    
    DuotoneMode dtMode = tm.currentTheme.duotoneMode;
    
    if (dtMode == DialStyleNone) {
        dtMode = DuotoneModeAngular;
    } else {
        --dtMode;
    }
    
    tm.currentTheme.duotoneMode = dtMode;
  
    [self refreshTheme];
}









-(void)refreshTheme
{
	[[NSUserDefaults standardUserDefaults] setInteger:tm.currentFaceIndex forKey:@"Theme"];

    SKNode *existingMarkings = [self childNodeWithName:@"Markings"];
	SKNode *existingDualMaskMarkings = [self childNodeWithName:@"Markings Alternate"];

	[existingMarkings removeAllChildren];
	[existingMarkings removeFromParent];
	
	[existingDualMaskMarkings removeAllChildren];
	[existingDualMaskMarkings removeFromParent];
	
	[self setupColors];
	[self setupScene];
	
	if (tm.currentTheme.useMasking && tm.currentTheme.duotoneMode != DuotoneModeNone)
	{
		[self setupMasking];
	}
}

#pragma mark -

#if TARGET_OS_OSX
- (void)keyDown:(NSEvent *)event
{
	char key = event.characters.UTF8String[0];
	
	if (key == 't')
	{
        [self nextTheme];
	}
	else if (key == 'n')
	{
        [self previousTheme];
	}

}
#endif
@end
