//
//  FaceScene.m
//  SpriteKitWatchFace
//
//  Created by Steven Troughton-Smith on 10/10/2018.
//  Copyright © 2018 Steven Troughton-Smith. All rights reserved.
//

#import "FaceScene.h"
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

@implementation FaceScene

@synthesize logo1, logo2, logo3;

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		
		self.faceSize = (CGSize){184, 224};
        
        self.theme = [[NSUserDefaults standardUserDefaults] integerForKey:@"Theme"];
		self.dialStyle = DialStyleAll;

        self.colorRegionStyle = ColorRegionStyleDynamicDuo;

        self.typeface = TypefaceNormal;
        
        self.useAlternateColorOnLogosAndDate = YES;
        
        self.updatingTypeFace = YES;
        
        
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
    
    if (self.dialStyle == DialStyleTweoveOnTop) { //12 only
        
        CGFloat fontSize = 25;
        
        SKSpriteNode *labelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(fontSize, fontSize)];
        labelNode.anchorPoint = CGPointMake(0.5,0.5);
        
        labelNode.position = CGPointMake(labelXMargin-self.faceSize.width/2 + ((12+1)%3) * (self.faceSize.width-labelXMargin*2)/3.0 + (self.faceSize.width-labelXMargin*2)/6.0, self.faceSize.height/2-labelYMargin);
        
        [faceMarkings addChild:labelNode];
        
        
        SKSpriteNode *numberImg = [SKSpriteNode spriteNodeWithTexture: [self textureForNumeral: 12]];
        numberImg.color = self.textColor;
        numberImg.colorBlendFactor = 1.0;
        numberImg.xScale = 0.8;
        numberImg.yScale = 0.8;
        numberImg.alpha = self.updatingTypeFace ? 0 : 1;
        
        [labelNode addChild: numberImg];
        
        if (self.updatingTypeFace) {
            [numberImg runAction: [SKAction fadeInWithDuration: 0.2]];
        }
        
        
    } if (self.dialStyle == DialStyleCardinal || self.dialStyle == DialStyleAll) {
    
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
            numberImg.color = self.textColor;
            numberImg.colorBlendFactor = 1.0;
            numberImg.xScale = 0.8;
            numberImg.yScale = 0.8;
            numberImg.alpha = self.updatingTypeFace ? 0 : 1.0;
            
            if (self.dialStyle == DialStyleAll || ((self.dialStyle == DialStyleCardinal) && (i % 3 == 0))) {

                [labelNode addChild: numberImg];
            } else if (i == 12 && self.dialStyle == DialStyleTweoveOnTop) {
                [labelNode addChild: numberImg];
            }
            
            [allNumbers addObject:numberImg];


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
    logo1Img.color = self.textColor;
    logo1Img.colorBlendFactor = 1.0;
    logo1Img.position = CGPointMake(0, (self.faceSize.height / 2) - (labelYMargin + 29));
    
    
    SKTexture *logo2Texture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusLogo2-394h"]];
    SKSpriteNode *logo2Img = [SKSpriteNode spriteNodeWithTexture: logo2Texture];
    [faceMarkings addChild:logo2Img];
    logo2Img.color = self.textColor;
    logo2Img.colorBlendFactor = 1.0;
    logo2Img.position = CGPointMake(logo1Img.position.x, (logo1Img.position.y - 13));
    
    SKTexture *moonTexture = [SKTexture textureWithImage:[NSImage imageNamed: @"ZeusMoon_0088-regular"]];
    SKSpriteNode *moonImg = [SKSpriteNode spriteNodeWithTexture: moonTexture];
    [faceMarkings addChild:moonImg];
    moonImg.color = self.textColor;
    moonImg.colorBlendFactor = 1.0;
    moonImg.position = CGPointMake(logo2Img.position.x, (logo1Img.position.y - 33));
            
    if (self.dialStyle != DialStyleNone) {
        
        SKSpriteNode *dayImg = [SKSpriteNode spriteNodeWithTexture: [self textureForToday]];
        [faceMarkings addChild:dayImg];
        dayImg.color = self.textColor;
        dayImg.colorBlendFactor = 1.0;
        dayImg.position = CGPointMake(logo2Img.position.x, -(self.faceSize.height / 2) + (labelYMargin + 37));
    }
	
	[self addChild:faceMarkings];
}


- (SKTexture *)textureForNumeral: (int)number {
    
    NSString *imgName = @"";

    switch (self.typeface) {
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
    
    NSString *finalDayString = [NSString stringWithFormat: @"ZeusDate-3-%@-394h", dayString];
    
    SKTexture *numberImage = [SKTexture textureWithImage:[NSImage imageNamed: finalDayString]];
    
    return numberImage;
}

#pragma Theme names cnvenience -

- (NSString *)themeNameFor: (int)theme {
    
    switch (self.theme) {
        case ThemeHermesPink: { return @"HermesPink"; }
        case ThemeHermesOrange: { return @"HermesOrange"; }
        case ThemeNavy: { return @"Navy"; }
        case ThemeTidepod: { return @"Tidepod"; }
        case ThemeBretonnia: { return @"Bretonnia"; }
        case ThemeNoir: { return @"Noir"; }
        case ThemeContrast: { return @"Contrast"; }
        case ThemeVictoire: { return @"Victoire"; }
        case ThemeLiquid: { return @"Liquid"; }
        case ThemeAngler: { return @"Angler"; }
        case ThemeSculley: { return @"Sculley"; }
        case ThemeKitty: { return @"Kitty"; }
        case ThemeDelay: { return @"Delay"; }
        case ThemeDiesel: { return @"Diesel"; }
        case ThemeLuxe: { return @"Luxe"; }
        case ThemeSage: { return @"Sage"; }
        case ThemeBondi: { return @"Bondi"; }
        case ThemeTangerine: { return @"Tangerine"; }
        case ThemeStrawberry: { return @"Strawberry"; }
        case ThemePawn: { return @"Pawn"; }
        case ThemeRoyal: { return @"Royal"; }
        case ThemeMarques: { return @"Marques"; }
        case ThemeVox: { return @"Vox"; }
        case ThemeSummer: { return @"Summer"; }
        default:
           return @"";
    }
}

#pragma mark -


-(void)setupColors
{
	SKColor *colorRegionColor = nil;
	SKColor *faceBackgroundColor = nil;
	SKColor *majorMarkColor = nil;
	SKColor *minorMarkColor = nil;
	SKColor *inlayColor = nil;
	SKColor *handColor = nil;
	SKColor *textColor = nil;
	SKColor *secondHandColor = nil;
	
	SKColor *alternateMajorMarkColor = nil;
	SKColor *alternateMinorMarkColor = nil;
	SKColor *alternateTextColor = nil;

	self.useMasking = NO;
	
    NSLog(@"Current theme: %@", [self themeNameFor:self.theme]);
    
	switch (self.theme) {
		case ThemeHermesPink:
		{
        
			colorRegionColor = [SKColor colorWithRed:0.848 green:0.187 blue:0.349 alpha:1];
			faceBackgroundColor = [SKColor colorWithRed:0.387 green:0.226 blue:0.270 alpha:1];
			majorMarkColor = [SKColor colorWithRed:0.831 green:0.540 blue:0.612 alpha:1];
			minorMarkColor = majorMarkColor;
			inlayColor = colorRegionColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeHermesOrange:
		{
            
			colorRegionColor = [SKColor colorWithRed:0.892 green:0.825 blue:0.745 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			majorMarkColor = [inlayColor colorWithAlphaComponent:0.5];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = inlayColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeNavy:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeTidepod:
		{
            
            colorRegionColor = [SKColor colorWithRed:1.000 green:0.450 blue:0.136 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.067 green:0.471 blue:0.651 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.953 green:0.569 blue:0.196 alpha:1.000];
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeBretonnia:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.067 green:0.420 blue:0.843 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.956 green:0.137 blue:0.294 alpha:1.000];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeNoir:
		{
            
            colorRegionColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			faceBackgroundColor = [SKColor blackColor];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeContrast:
		{
            
            colorRegionColor = [SKColor whiteColor];
			faceBackgroundColor = [SKColor whiteColor];
			inlayColor = [SKColor whiteColor];
			majorMarkColor = [SKColor blackColor];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor blackColor];
			textColor = [SKColor blackColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeVictoire:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.749 green:0.291 blue:0.319 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.391 green:0.382 blue:0.340 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.649 green:0.191 blue:0.219 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.937 green:0.925 blue:0.871 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = majorMarkColor;
			textColor = majorMarkColor;
			secondHandColor = [SKColor colorWithRed:0.949 green:0.491 blue:0.619 alpha:1.000];
			break;
		}
		case ThemeLiquid:
		{
            
            colorRegionColor = [SKColor colorWithWhite:0.2 alpha:1.0];
			faceBackgroundColor = colorRegionColor;
			inlayColor = [SKColor colorWithWhite:0.3 alpha:1.0];
			majorMarkColor = [SKColor colorWithWhite:0.5 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor whiteColor];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeAngler:
		{
            
            colorRegionColor = [SKColor blackColor];
			faceBackgroundColor = [SKColor blackColor];
			inlayColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			majorMarkColor = inlayColor;
			minorMarkColor = majorMarkColor;
			handColor = [inlayColor colorWithAlphaComponent:0.4];
			textColor = inlayColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeSculley:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.180 green:0.600 blue:0.282 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.180 green:0.800 blue:0.482 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			textColor = [SKColor colorWithRed:0.080 green:0.300 blue:0.082 alpha:1.000];
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeKitty:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.447 green:0.788 blue:0.796 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.459 green:0.471 blue:0.706 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.259 green:0.271 blue:0.506 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor colorWithWhite:0.9 alpha:1];
			textColor = [SKColor colorWithRed:0.159 green:0.171 blue:0.406 alpha:1.000];
			secondHandColor = [SKColor colorWithRed:0.976 green:0.498 blue:0.439 alpha:1.000];
			break;
		}
		case ThemeDelay:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.941 green:0.408 blue:0.231 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.282 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.941 green:0.708 blue:0.531 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = majorMarkColor;
			break;
		}
		case ThemeDiesel:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.702 green:0.212 blue:0.231 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.027 green:0.251 blue:0.502 alpha:1.000];
			inlayColor = [SKColor colorWithRed:0.502 green:0.212 blue:0.231 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = [SKColor colorWithRed:0.802 green:0.412 blue:0.431 alpha:1.000];
			break;
		}
		case ThemeLuxe:
		{
            
            colorRegionColor = [SKColor colorWithWhite:0.082 alpha:1.000];
			faceBackgroundColor = [SKColor blackColor];
			inlayColor = [SKColor colorWithRed:0.969 green:0.878 blue:0.780 alpha:1.000];
			majorMarkColor = [SKColor colorWithRed:0.804 green:0.710 blue:0.639 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = majorMarkColor;
			textColor = handColor;
			secondHandColor = inlayColor;
			break;
		}
		case ThemeSage:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.357 green:0.678 blue:0.600 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.264 green:0.346 blue:0.321 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.607 green:0.754 blue:0.718 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = handColor;
			secondHandColor = inlayColor;
			break;
		}
		case ThemeBondi:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.086 green:0.584 blue:0.706 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1.0];
			secondHandColor = [SKColor colorWithRed:0.486 green:0.784 blue:0.906 alpha:1.000];
			
            
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemeTangerine:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.992 green:0.502 blue:0.192 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1.0];
			secondHandColor = [SKColor colorWithRed:0.992 green:0.702 blue:0.392 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemeStrawberry:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.831 green:0.161 blue:0.420 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1];
			secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			alternateMajorMarkColor = [SKColor colorWithWhite:0.6 alpha:1];
			
			self.useMasking = YES;
			break;
		}
		case ThemePawn:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.196 green:0.329 blue:0.275 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.846 green:0.847 blue:0.757 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.365 green:0.580 blue:0.506 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1.0 alpha:1];
			secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
			
			alternateTextColor = colorRegionColor;
			alternateMinorMarkColor = colorRegionColor;
			alternateMajorMarkColor = colorRegionColor;
			
			self.useMasking = YES;
			break;
		}
		case ThemeRoyal:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.118 green:0.188 blue:0.239 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithWhite:0.9 alpha:1.0];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithRed:0.318 green:0.388 blue:0.539 alpha:1.000];
			minorMarkColor = majorMarkColor;
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:0.9 alpha:1];
			secondHandColor = [SKColor colorWithRed:0.912 green:0.198 blue:0.410 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithRed:0.218 green:0.288 blue:0.439 alpha:1.000];
			alternateMinorMarkColor = alternateTextColor;
			alternateMajorMarkColor = alternateTextColor;
			
			self.useMasking = YES;
			break;
		}
		case ThemeMarques:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.886 green:0.141 blue:0.196 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.145 green:0.157 blue:0.176 alpha:1.000];
			inlayColor = colorRegionColor;
			majorMarkColor = [SKColor colorWithWhite:1 alpha:0.8];
			minorMarkColor = [faceBackgroundColor colorWithAlphaComponent:0.5];
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1 alpha:1];
			secondHandColor = [SKColor colorWithWhite:0.9 alpha:1];
			
            NSColor *logoAndDateColor = textColor;
            if (self.useAlternateColorOnLogosAndDate) {
                logoAndDateColor = [SKColor colorWithRed:0.886 green:0.141 blue:0.196 alpha:1.000];
            }
            
			alternateTextColor = logoAndDateColor;
			alternateMinorMarkColor = [colorRegionColor colorWithAlphaComponent:0.5];
			alternateMajorMarkColor = [SKColor colorWithWhite:1 alpha:0.8];
			
			self.useMasking = YES;
			break;
		}
		case ThemeVox:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.914 green:0.086 blue:0.549 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.224 green:0.204 blue:0.565 alpha:1.000];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor colorWithRed:0.324 green:0.304 blue:0.665 alpha:1.000];
			minorMarkColor = [SKColor colorWithWhite:0.831 alpha:0.5];
			handColor = [SKColor whiteColor];
			textColor = [SKColor colorWithWhite:1 alpha:1.000];
			secondHandColor = [SKColor colorWithRed:0.914 green:0.486 blue:0.949 alpha:1.000];
			
			alternateTextColor = [SKColor colorWithWhite:1 alpha:1.000];
			alternateMinorMarkColor = [SKColor colorWithWhite:0.831 alpha:0.5];
			alternateMajorMarkColor = [SKColor colorWithRed:0.914 green:0.086 blue:0.549 alpha:1.000];
			
			self.useMasking = YES;
			break;
		}
		case ThemeSummer:
		{
            
            colorRegionColor = [SKColor colorWithRed:0.969 green:0.796 blue:0.204 alpha:1.000];
			faceBackgroundColor = [SKColor colorWithRed:0.949 green:0.482 blue:0.188 alpha:1.000];
			inlayColor = faceBackgroundColor;
			majorMarkColor = [SKColor whiteColor];
			minorMarkColor = [SKColor colorWithRed:0.267 green:0.278 blue:0.271 alpha:0.3];
			handColor = [SKColor colorWithRed:0.467 green:0.478 blue:0.471 alpha:1.000];
			textColor = [SKColor colorWithRed:0.949 green:0.482 blue:0.188 alpha:1.000];
			secondHandColor = [SKColor colorWithRed:0.649 green:0.282 blue:0.188 alpha:1.000];
			
			alternateTextColor = [SKColor whiteColor];
			alternateMinorMarkColor = minorMarkColor;
			alternateMajorMarkColor = majorMarkColor;
			
            self.useMasking = YES;
			break;
		}
		default:
			break;
	}
	
	self.colorRegionColor = colorRegionColor;
	self.faceBackgroundColor = faceBackgroundColor;
	self.majorMarkColor = majorMarkColor;
	self.minorMarkColor = minorMarkColor;
	self.inlayColor = inlayColor;
	self.textColor = textColor;
	self.handColor = handColor;
	self.secondHandColor = secondHandColor;
	
	self.alternateMajorMarkColor = alternateMajorMarkColor;
	self.alternateMinorMarkColor = alternateMinorMarkColor;
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
    self.datePlaceHolder.color = self.alternateTextColor;
    self.datePlaceHolder.colorBlendFactor = 1.0;
    
	
    [hourHand runAction: [SKAction colorizeWithColor: self.handColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	[minuteHand runAction: [SKAction colorizeWithColor: self.handColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	[secondHand runAction: [SKAction colorizeWithColor: self.secondHandColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
    [self runAction: [SKAction colorizeWithColor: self.faceBackgroundColor colorBlendFactor: 1 duration: regionTransitionDuration]];
    
    [colorRegion runAction: [SKAction colorizeWithColor: self.colorRegionColor colorBlendFactor: 1 duration: regionTransitionDuration]];
	
	numbers.color = self.textColor;
	numbers.colorBlendFactor = 1.0;
	
	hourHandInlay.color = self.inlayColor;
	hourHandInlay.colorBlendFactor = 1.0;
	
	minuteHandInlay.color = self.inlayColor;
	minuteHandInlay.colorBlendFactor = 1.0;
		
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
	
	self.textColor = self.alternateTextColor;
	self.minorMarkColor = self.alternateMinorMarkColor;
	self.majorMarkColor = self.alternateMajorMarkColor;
    
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
	
	SKNode *colorRegion = [face childNodeWithName:@"Color Region"];
	SKNode *colorRegionReflection = [face childNodeWithName:@"Color Region Reflection"];

	hourHand.zRotation =  - (2*M_PI)/12.0 * (CGFloat)(components.hour%12 + 1.0/60.0*components.minute);
	minuteHand.zRotation =  - (2*M_PI)/60.0 * (CGFloat)(components.minute + 1.0/60.0*components.second);
	secondHand.zRotation = - (2*M_PI)/60 * (CGFloat)(components.second + 1.0/NSEC_PER_SEC*components.nanosecond);
	
	
	if (self.colorRegionStyle == ColorRegionStyleDynamicDuo)
	{
//        colorRegion.alpha = 1.0;
        
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

-(void)nextTypeface {
    
    if (self.typeface >= TypefaceMAX - 1) {
        self.typeface = 0;
    } else {
        self.typeface++;
    }
}

-(void)nextColorRegionStyle {
    if (self.colorRegionStyle >= ColorRegionStyleMAX - 1) {
        self.colorRegionStyle = 0;
    } else {
        self.colorRegionStyle++;
    }
}


-(void)nextColorDialStyle {
    if (self.dialStyle >= DialStyleMAX - 1) {
        self.dialStyle = 0;
    } else {
        self.dialStyle++;
    }
}

-(void)refreshTheme
{
	[[NSUserDefaults standardUserDefaults] setInteger:self.theme forKey:@"Theme"];
	
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
