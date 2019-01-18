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

CGFloat workingRadiusForFaceOfSizeWithAngle(CGSize faceSize, CGFloat angle)
{
	CGFloat faceHeight = faceSize.height;
	CGFloat faceWidth = faceSize.width;
	
	CGFloat workingRadius = 0;
	
	double vx = cos(angle);
	double vy = sin(angle);
	
	double x1 = 0;
	double y1 = 0;
	double x2 = faceHeight;
	double y2 = faceWidth;
	double px = faceHeight/2;
	double py = faceWidth/2;
	
	double t[4];
	double smallestT = 1000;
	
	t[0]=(x1-px)/vx;
	t[1]=(x2-px)/vx;
	t[2]=(y1-py)/vy;
	t[3]=(y2-py)/vy;
	
	for (int m = 0; m < 4; m++)
	{
		double currentT = t[m];
		
		if (currentT > 0 && currentT < smallestT)
			smallestT = currentT;
	}
	
	workingRadius = smallestT;
	
	return workingRadius;
}

CGFloat regionTransitionDuration = 0.2;


@interface FaceScene()


@property (nonatomic, retain) ThemeManager *tm;


@end

@implementation FaceScene

@synthesize logo1, logo2, logo3, bgColor1, bgColor2, hourMinuteColor, secondsHandColor, innerColor, outerColor, typefaceColor, logoAndDateColor, showSeconds, dateFontIdentifier, crownEditMode, tm;

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
        self.tm = [ThemeManager sharedInstance];
        
		self.faceSize = (CGSize){184, 224};
        
        self.colorRegionStyle = ColorRegionStyleDynamicDuo;
        
        self.useAlternateColorOnLogosAndDate = YES;
        
        self.updatingTypeFace = YES;
        
        self.dateFontIdentifier = DateFontNormal;
        
        showSeconds = YES;
        
        crownEditMode = EditModeNone;
        
        [tm setCurrentFaceIndex: [[NSUserDefaults standardUserDefaults] integerForKey:@"Theme"]]; //ThemeHermesBlackOrange; //
        
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
	
	/* Numerals */
    
    FaceTheme *theme = [tm currentTheme];

    if (theme.dialStyle == DialStyleTweoveOnTop) { //12 only
        
        CGFloat fontSize = 25;
        
        SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
        labelNode.anchorPoint = CGPointMake(0.5,0.5);
        
        labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + ((12+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, self.faceSize.height/2-labelYMargin);
        
        [faceMarkings addChild:labelNode];
        
        SKSpriteNode *numberImg = [SKSpriteNode spriteNodeWithTexture: [self textureForNumeral: 12]];
        numberImg.color = theme.typefaceColor;
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
            numberImg.color = theme.typefaceColor;
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
    
    SKTexture *logo1Texture = [SKTexture textureWithImage: [NSImage imageNamed: @"ZeusLogo1-394h"]];
    SKSpriteNode *logo1Img = [SKSpriteNode spriteNodeWithTexture: logo1Texture];
    [faceMarkings addChild:logo1Img];
    logo1Img.color = theme.logoAndDateColor;
    logo1Img.colorBlendFactor = 1.0;
    logo1Img.xScale = 1.2;
    logo1Img.yScale = 1.2;
    logo1Img.position = CGPointMake(0, (self.faceSize.height / 2) - (labelYMargin + 25));
    
    
    SKTexture *logo2Texture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusLogo2-394h"]];
    SKSpriteNode *logo2Img = [SKSpriteNode spriteNodeWithTexture: logo2Texture];
    [faceMarkings addChild:logo2Img];
    logo2Img.color = theme.logoAndDateColor;
    logo2Img.colorBlendFactor = 1.0;
    logo2Img.xScale = 1.2;
    logo2Img.yScale = 1.2;
    logo2Img.position = CGPointMake(logo1Img.position.x, (logo1Img.position.y - 11));
    
    SKTexture *moonTexture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusMoon_0088-regular"]];
    SKSpriteNode *moonImg = [SKSpriteNode spriteNodeWithTexture: moonTexture];
    [faceMarkings addChild:moonImg];
    moonImg.color = theme.logoAndDateColor;
    moonImg.colorBlendFactor = 1.0;
    moonImg.position = CGPointMake(logo2Img.position.x, (logo1Img.position.y - 27));
            
    if (theme.dialStyle != DialStyleNone) {
        
        SKSpriteNode *dayImg = [SKSpriteNode spriteNodeWithTexture: [self textureForToday]];
        [faceMarkings addChild:dayImg];
        dayImg.color = theme.logoAndDateColor;
        dayImg.colorBlendFactor = 1.0;
        dayImg.position = CGPointMake(logo2Img.position.x, -(self.faceSize.height / 2) + (labelYMargin + 40));
    }
	
	[self addChild:faceMarkings];
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

#pragma Theme names cnvenience -

- (NSString *)themeNameFor: (int)theme {
    
    switch (self.theme) {
        case ThemeHermesRose: { return @"Rose"; }
        case ThemeHermesOrange: { return @"Orange"; }
        case ThemeHermesYellowPink: { return @"YellowPink"; }
        case ThemeHermesBlackElegance: { return @"BlackElegance"; }
        case ThemeHermesBlackOrange: { return @"BlackOrange"; }
//        case ThemeContrast: { return @"ThemeContrast"; }
//        case ThemeMarques: { return @"ThemeMarques"; }
//        case ThemeNavy: { return @"ThemeNavy"; }
//        case ThemeRoyal: { return @"ThemeRoyal"; }
//        case ThemeTidepod: { return @"ThemeTidepod"; }
//        case ThemeSummer: { return @"ThemeSummer"; }
//        case ThemeBretonnia: { return @"ThemeBretonnia"; }
        default:
            return @"";
    }
}

#pragma mark -


-(void)setupColors
{
	SKColor *alternateTextColor = nil;

	self.useMasking = NO;
	
    [self showThemenameOnScreenIfNeeded];


	self.alternateTextColor = alternateTextColor;
    
}

-(void)showThemenameOnScreenIfNeeded {
    NSLog(@"theme: %@", [tm currentTheme].name);
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
//    self.datePlaceHolder.color = self.alternateTextColor;
//    self.datePlaceHolder.colorBlendFactor = 1.0;
    
    FaceTheme *theme = [tm currentTheme];
    
    [hourHand runAction: [SKAction colorizeWithColor: theme.outerColor colorBlendFactor: 1 duration: regionTransitionDuration]];

    [hourHandInlay runAction: [SKAction colorizeWithColor: theme.innerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	[minuteHand runAction: [SKAction colorizeWithColor: theme.outerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
    
    [minuteHandInlay runAction: [SKAction colorizeWithColor: theme.innerColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
    [secondHand runAction: [SKAction colorizeWithColor: theme.secondsHandColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
    [self runAction: [SKAction colorizeWithColor: theme.bgColor2 colorBlendFactor: 1 duration: regionTransitionDuration]];
    
    [colorRegion runAction: [SKAction colorizeWithColor: theme.bgColor1 colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	numbers.color = theme.typefaceColor;
	numbers.colorBlendFactor = 1.0;
	

    secondHand.color = theme.secondsHandColor;
    secondHand.colorBlendFactor = 1.0;
		
	if (self.colorRegionStyle == ColorRegionStyleNone)
	{
        colorRegion.alpha = 0.0;
		
	}
	else if (self.colorRegionStyle == ColorRegionStyleDynamicDuo)
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
	
	
	if (self.colorRegionStyle == ColorRegionStyleDynamicDuo)
	{
        [colorRegion runAction: [SKAction fadeInWithDuration:0.20]];
        
        CGFloat regionDesiredRotation = M_PI_2 -(2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
        
        [colorRegion runAction: [SKAction rotateToAngle:regionDesiredRotation duration:0.2 shortestUnitArc:YES]];
        
         CGFloat reflectionDesiredRotation = M_PI_2 - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
        
        [colorRegionReflection runAction: [SKAction rotateToAngle:reflectionDesiredRotation duration:0.2 shortestUnitArc:YES]];
	}
	else if (self.colorRegionStyle == ColorRegionStyleHalfHorizontal)
	{
		colorRegion.alpha = 1.0;

        CGFloat desiredRotation = 0;
        
        SKAction *rotation = [SKAction rotateToAngle:desiredRotation duration:0.15 shortestUnitArc:YES];
        
        [colorRegionReflection runAction: rotation];
        [colorRegion runAction: rotation];
        
    } else if (self.colorRegionStyle == ColorRegionStyleHalfVertical) {
        
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
    
    switch (crownEditMode) {
        case EditModeFace:
            [self nextTheme];
            break;
            
        case EditModeTypeface:
            [self nextTypeface];
            break;
            
        case EditModeDialStyle:
            [self nextColorDialStyle];
            break;
            
        default:
            break;
    }
}
-(void)digitalCrownScrolledDown {
    
    switch (crownEditMode) {
        case EditModeFace:
            [self previousTheme];
            break;
            
        case EditModeTypeface:
            [self previousTypeface];
            break;
            
        case EditModeDialStyle:
            [self previousColorDialStyle];
            break;
            
        default:
            break;
    }
}

-(void)resetStyles {
//    [tm setCurrentFaceIndex: ThemeHermesBlackOrange];
    [tm buildThemeList];
    crownEditMode = EditModeNone;
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



-(void)nextColorRegionStyle {
    if (self.colorRegionStyle >= ColorRegionStyleMAX - 1) {
        self.colorRegionStyle = 0;
    } else {
        self.colorRegionStyle++;
    }
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
	
	if (self.useMasking && ((self.colorRegionStyle == ColorRegionStyleDynamicDuo) || (self.colorRegionStyle == ColorRegionStyleHalfHorizontal)  || (self.colorRegionStyle == ColorRegionStyleHalfVertical)))
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
		int direction = 1;
		
		if ((self.theme+direction > 0) && (self.theme+direction < ThemeMAX))
			self.theme += direction;
		else
			self.theme = 0;
	}
	else if (key == 'n')
	{
        if (self.dialStyle+1 > 0) {
			self.dialStyle ++;
        } else
			self.dialStyle = 0;
	}

	
	[self refreshTheme];
}
#endif
@end
