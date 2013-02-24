//
//  OpenSpringBoardVC.m
//  openspringboard
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "OpenSpringBoardVC.h"
//#import <VVOSC/VVOSC.h>


@implementation OpenSpringBoardVC

@synthesize openSpringBoard = _openSpringBoard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//! Custom initialization to add logo image
		self.title = @"OpenSpringBoardVC";
		
		UIBarButtonItem *modalButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						 target:self
																						 action:@selector(doneButton:)];
		
		self.navigationItem.rightBarButtonItem = modalButtonDone;
//		[modalButtonDone release];
		
	}
	return self;
}

- (IBAction) doneButton: (id)sender
{
	//[mainLoopTimer invalidate];
	[[self navigationController] popToRootViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	_openSpringBoard = [[OpenSpringBoard alloc] init];
	_openSpringBoard.delegate = self;
	[self.view addSubview:_openSpringBoard.view];
    
    initDate = [NSDate date];
    errorsCount = 0;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//
//- (void)dealloc {
//    [super dealloc];
//}

#pragma mark OpenSpringBoard Delegate Methods

- (NSMutableArray *) openSringBoardLoadIconArray:(OpenSpringBoard *)openSringBoardVC iconPageLimit:(int *)numIcons
{
// Create an array of icons programmatically
#define addIcon(png,title,code,schema) d = [NSDictionary dictionaryWithObjectsAndKeys:png,@"icon_png",title,@"icon_title",code,@"icon_code",schema,@"icon_schema", nil]; [itemArray addObject:d];

	NSDictionary *d;
	itemArray = [[NSMutableArray alloc] initWithCapacity:MAX_ICON_POSITION*2];

    addIcon(@"music.png",@"Music",@"2",@"music:")
    
    NSString *title = @"title";
    float latitude = 35.4634;
    float longitude = 9.43425;
    int zoom = 13;
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
    addIcon(@"maps.jpeg",@"Maps",@"3",stringURL)
    
    addIcon(@"facebook.png",@"Facebook",@"4",@"fb:")
    addIcon(@"twitter.png",@"Twitter",@"5",@"twitter:")
    addIcon(@"skype.png",@"Skype",@"6",@"skype:")
    
    addIcon(@"youtube.jpg",@"Youtube",@"7",@"youtube:")
    addIcon(@"IMDb.jpg",@"IMDb",@"8",@"imdb:")
    addIcon(@"appStore.png",@"App Store",@"9",@"https://itunes.apple.com/es/app/cepsa/id423985302?mt=8")
    
    addIcon(@"ted.png",@"TED",@"10",@"ted:")
    addIcon(@"spotify.jpg",@"Spotify",@"11",@"spotify:")
    addIcon(@"mail.png",@"Mail",@"12",@"mailto:test@example.com")
    
    addIcon(@"linkedin.png",@"Linkedin",@"13",@"linkedin:")
    addIcon(@"kayak.jpg",@"Kayak",@"14",@"kayak:")
    addIcon(@"instagram.png",@"May2",@"15",@"instagram:")
    
    addIcon(@"gmail.jpg",@"Gmail",@"16",@"googlegmail:")
    addIcon(@"flipboard-icon.png",@"Flipboard",@"17",@"Flipboard:")
    addIcon(@"ratp.jpg",@"Ratp",@"18",@"ratp:")

    addIcon(@"tool_calendar_FEB.png",@"Google",@"19",@"google:")
    addIcon(@"chrome.png",@"Chrome",@"20",@"googlechrome:")
    addIcon(@"evernote.png",@"Evernote",@"21",@"evernote:")
    
    addIcon(@"googledrive.jpg",@"Drive",@"22",@"googleDrive:")
    addIcon(@"ambiance.jpg",@"Ambiance",@"23",@"amb://home:")
    addIcon(@"AppigoTodo.jpg",@"Todo",@"24",@"appigotodo://")
    
    addIcon(@"CobiTools.jpg",@"Cobi Tools",@"25",@"cobitools://:")
    addIcon(@"DailyMotion.jpg",@"Daily Motion",@"26",@"dailymotion://:")
    addIcon(@"Darkslide.jpg",@"Darkslide",@"27",@"exposure://:")
    
    addIcon(@"Echofon.jpg",@"Echofon",@"28",@"twitterfon//:")
    addIcon(@"Explorimmo.jpg",@"Explorimmo",@"29",@"explorimmo://")
    addIcon(@"GCBuddy.jpg",@"GCBuddy",@"30",@"")
    
    NSString *lat = @"12.345";
    NSString *lon = @"6.789";
    NSString *waypoint = @"GC12345";
    stringURL = [NSString stringWithFormat:@"geopherlite://setTarget;lat=%@;lon=%@;waypoint=%@", lat, lon, waypoint];
    addIcon(@"GeopherLite.jpg",@"Geopher",@"31",stringURL)
    addIcon(@"GoogleEarth.jpg",@"Google Earth",@"32",@"comgoogleearth://")
    addIcon(@"iBooks.jpg",@"iBooks",@"33",@"ibooks://")
    
    addIcon(@"ImageData.jpg",@"Image Data",@"34",@"")
    addIcon(@"INRIXTraffic.jpg",@"INRIX",@"35",@"inrixtraffic://")
    addIcon(@"IntCall.jpg",@"IntCall",@"36",@"")
    
    addIcon(@"iTranslate.jpg",@"iTranlate",@"37",@"itranslate://")
    addIcon(@"iWavitTabulaRasa.jpg",@"iWavitTabulaRasa",@"38",@"wavittabularasa://")
    addIcon(@"JunosPulse.jpg",@"Junos Pulse",@"39",@"junospulse://")
    
    addIcon(@"OperaMini.jpg",@"Opera",@"40",@"ohttp://www.opera.com/")
    addIcon(@"pic2shop.jpg",@"Pic2Shop",@"41",@"pic2shop://")
    addIcon(@"Pinterest.jpg",@"Pinterest",@"42",@"pinit12://")
    
    addIcon(@"Portscan.jpg",@"Portscan",@"43",@"")
    addIcon(@"Round Tuit.jpg",@"Round Tuit",@"44",@"roundtuit://")
    addIcon(@"TikiSurf.jpg",@"TikiSurf",@"45",@"tikisurf://")
	
    addIcon(@"TimeLog.jpg",@"TimeLog",@"46",@"timelog://")
    addIcon(@"TwittelatorPro.jpg",@"Twittelator",@"47",@"twit://")
    addIcon(@"Twitterriffic.jpg",@"Twitterriffic",@"48",@"")

    addIcon(@"Unfragment.jpg",@"Unfragment",@"49",@"unfragment://")
    addIcon(@"waze.jpg",@"Waze",@"50",@"waze://")
    addIcon(@"Wikiamo.jpg",@"Wikiamo",@"51",@"wikiamo://")
    
    addIcon(@"Seesmic.jpg",@"Seesmic",@"52",@"seesmic://")
    addIcon(@"waze.jpg",@"Waze",@"53",@"waze://")
    addIcon(@"Wikiamo.jpg",@"Wikiamo",@"54",@"wikiamo://")

    addIcon(@"foursquare.png",@"Foursquare",@"55",@"foursquare://")
    addIcon(@"yelp.png",@"Yelp",@"56",@"yelp://")
    addIcon(@"wikipedia.jpg",@"wikipedia",@"57",@"wikipedia://")
    addIcon(@"Safari.png",@"Safari",@"1",@"http://www.google.com/")

    
	*numIcons = MAX_ICON_POSITION;
	
	return itemArray;
}

- (void) openSringBoardIconPress:(OpenSpringBoard *)openSringBoardVC iconSelectedTag:(int)iconTag
{
	
    
    if (appToOpen == (iconTag-1)) {
        
        NSDate *endDate = [NSDate date];
        NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:initDate];
        
        NSInteger time = secondsBetween; //TODO: calculate
        
        [delegate measusesObtainedTime:time
                                errors:errorsCount
                                   app:appToOpen];
        
    } else {
        errorsCount ++;
    }
    
//    // Handle icon press
//	NSLog(@"OpenSpringBoardVC: launchTool=%d",iconTag);    
//    NSDictionary *schema = [itemArray objectAtIndex:iconTag-1];
//  
//    NSString *stringURL = [schema objectForKey:@"icon_schema"];
//    
//    BOOL canOpen = NO;
//    if (![stringURL isEqualToString:@""]) {
//        
//        NSURL *url = [NSURL URLWithString:stringURL];
//        
//        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//            canOpen = YES;
//            [[UIApplication sharedApplication] openURL:url];
//
//        }
//        
//    }
//    
//    if (!canOpen) {
//    
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
//                                                        message:@"The application you try to open is not installed in your device or it is impossible to open."
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        
//        [alert show];
//    
//    }

}

- (void) openSringBoardDidReorderIcons:(OpenSpringBoard *)openSringBoardVC iconArray:(NSMutableArray *)iconArray
{
	// Respond to new ordered array of icons, save to NSDefaults?
	for (NSDictionary *item in itemArray) {
		NSLog(@"Icon image: %@  title: %@  code: %@",
			  [item objectForKey:@"icon_png"],
			  [item objectForKey:@"icon_title"],
			  [item objectForKey:@"icon_code"]);
	}
	
}



@end
