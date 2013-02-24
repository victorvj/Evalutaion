//
//  OpenSpringBoard.m
//  ScrollTests
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import "OpenSpringBoard.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/time.h>


static double
GetCurrentTime(void)
{
    struct timeval time;
	
    gettimeofday(&time, nil);
    return (double)time.tv_sec + (0.000001 * (double)time.tv_usec);
}



@implementation OpenSpringBoard

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//! Custom initialization to add logo image		
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	

//	CAGradientLayer *gradient = [CAGradientLayer layer];
//	gradient.frame = self.view.bounds;
//	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
//	[self.view.layer insertSublayer:gradient atIndex:0];
	
    [[self view] setBackgroundColor:[UIColor whiteColor]];
	maxIconPerPage = MAX_ICON_POSITION;
	[self buildIconViews];
	toolButtonSelected.hidden = YES;	

	//[self setupIconCollisionMatrix];
	toolButtonSelectedIndex = 0;	// testing, indicate outside position
		
	mainLoopTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/30) target:self selector:@selector(mainLoop:) userInfo:nil repeats:YES];

	[self setupGestureRecognition];
	
	isUserMovingIcons = NO;
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

	[mainLoopTimer invalidate];
}


//- (void)dealloc {
//    [super dealloc];
//}

#pragma mark UIButton Methods

- (IBAction) launchTool:(id)sender
{
	UIButton *button = (UIButton *)sender;
	//NSLog(@"OpenSpringBoard: launchTool=%d",button.tag);
	if([delegate respondsToSelector:@selector(openSringBoardIconPress:iconSelectedTag:)]) {
		[delegate openSringBoardIconPress:self iconSelectedTag:button.tag];
	}
	
}

#pragma mark Icon View Methods

-(void) buildIconViews
{
	//! Method to programmatically build icon views
	
    // Create the scrollview cna page control programmatically
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(141, 374, 38, 36)];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor blackColor]];
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.view addSubview:pageControl];
    pageOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
    pageTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
    pageThree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
    pageFour = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
//    pageFive = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 347)];
    
	/*** Refactor to delegate method
	// Create an array of icons programmatically
#define addIcon(png,title,code) d = [NSDictionary dictionaryWithObjectsAndKeys:png,@"icon_png",title,@"icon_title",code,@"icon_code",nil]; [itemArray addObject:d];
	
	NSDictionary *d;
	NSMutableArray *itemArray = [[[NSMutableArray alloc] initWithCapacity:18] autorelease];
		
	addIcon(@"tool_calendar_JAN.png",@"January",@"1")
	addIcon(@"tool_calendar_FEB.png",@"February",@"2")
	addIcon(@"tool_calendar_MAR.png",@"March",@"3")
	addIcon(@"tool_calendar_APR.png",@"April",@"4")
	addIcon(@"tool_calendar_MAY.png",@"May",@"5")
	
	***/
	
	NSMutableArray *itemArray;	// Array of dictionary items, describing icon title, image, and tag
	
	if([delegate respondsToSelector:@selector(openSringBoardLoadIconArray:iconPageLimit:)]) {
		itemArray = [delegate openSringBoardLoadIconArray:self iconPageLimit:&maxIconPerPage];
	}
	
	// Loop over all subviews (icons) and stuff into ordered array
//	iconViews = [[[NSMutableArray alloc] initWithCapacity:16] retain];
    iconViews = [[NSMutableArray alloc] initWithCapacity:16];

	for (NSDictionary *item in itemArray) {
		[[NSBundle mainBundle] loadNibNamed:@"ToolsIconView" owner:self options:nil];
		ToolsIconView *iconView = toolIconView;
		toolIconView = nil;			
		UIImage *i = [UIImage imageNamed:[item objectForKey:@"icon_png"]];
		[iconView.toolIconButton setImage:i forState:UIControlStateNormal];
		iconView.toolIconButton.tag = [(NSString *)[item objectForKey:@"icon_code"] intValue];
		[iconView.toolIconButton addTarget:self action:@selector(launchTool:) forControlEvents:UIControlEventTouchUpInside];
		iconView.toolIconButton.containerView = self.view;
		iconView.badgeCountLabel.text = @"00";
		iconView.badgeCountLabel.hidden = ([[item objectForKey:@"icon_code"] intValue] == 2 ? NO : YES);
		iconView.toolLabel.text = [item objectForKey:@"icon_title"];
		//[pageOne addSubview:iconView];
		[iconViews addObject:iconView];
		
	}
	
	// Build static matix (linear array) of icon positions and bounding circles
#define cpv(x,y) CGPointMake(x,y)
	int num = MAX_ICON_POSITION, x1=40, x2=120, x3=200, x4=280, y1=40, y2=130, y3=220, y4=310;
	CGPoint verts[] = {
        
		cpv(x1,y1), cpv(x2,y1), cpv(x3,y1), cpv(x4,y1),
		cpv(x1,y2), cpv(x2,y2), cpv(x3,y2), cpv(x4,y2),
		cpv(x1,y3), cpv(x2,y3), cpv(x3,y3), cpv(x4,y3),
        cpv(x1,y4), cpv(x2,y4), cpv(x3,y4), cpv(x4,y4),
        
	};
	
	// Stuff verts into global
	for (int j=0; j<num; j++) {
		iconVerts[j] = verts[j];		
	}
	
	// Loop over all icon views & move to position as per the vert matrix
	int i=0, page=1;
	for (UIView *view in iconViews) {
		if (i<num) {
			if (page==1) {
				[pageOne addSubview:view];			// [pageOne addSubview:view];
			} else if (page==2) {
				[pageTwo addSubview:view];			// [pageTwo addSubview:view];
			} else if (page==3) {
				[pageThree addSubview:view];			// [pageTwo addSubview:view];
			} else if (page==4) {
				[pageFour addSubview:view];			// [pageTwo addSubview:view];
			}
//            else if (page==5) {
//				[pageFive addSubview:view];			// [pageTwo addSubview:view];
//			}
			//NSLog(@"view.tag=%d (%.2f,%.2f)",i,iconVerts[i].x,iconVerts[i].y);
			view.center = CGPointMake(iconVerts[i].x,iconVerts[i].y);
		}
		if (++i == maxIconPerPage) {
			i=0;	// Reset for 9 icons per page, default
			page++;
		}
	}
	
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * (page*4), 380);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
	
	//! Stuff the static views into the scroll view
	[scrollView addSubview:pageOne];
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * 1;
	frame.origin.y = 0;
	pageTwo.frame = frame;
	[scrollView addSubview:pageTwo];
    frame.origin.x = frame.size.width * 2;
	frame.origin.y = 0;
	pageThree.frame = frame;
	[scrollView addSubview:pageThree];
    frame.origin.x = frame.size.width * 3;
	frame.origin.y = 0;
	pageFour.frame = frame;
	[scrollView addSubview:pageFour];
//    frame.origin.x = frame.size.width * 4;
//	frame.origin.y = 0;
//	pageFive.frame = frame;
//	[scrollView addSubview:pageFive];

}

- (void) listIconOrder
{
	//! Method to list icon info, sequentially
	for (UIView *view in iconViews) {
		//! Loop over all the iconViews, set up long press gesture recognizer
		if ([view class] == [ToolsIconView class]) {
			ToolsIconView *toolView = (ToolsIconView *)view;
			NSLog(@"%@ - %d", toolView.toolLabel.text, toolView.toolIconButton.tag);
		}			
		if ([view class] == [NSNull class]) {
			NSLog(@"Null");
		}			
	}
}

- (NSMutableArray *) createOrderedIconDictionaryArray
{
	//! Method to create an ordered array of icon dictionaries, after the user re-arranges the icons
#define addIcon(png,title,code) d = [NSDictionary dictionaryWithObjectsAndKeys:png,@"icon_png",title,@"icon_title",code,@"icon_code",nil]; [itemArray addObject:d];
	
	NSDictionary *d;
	
	NSMutableArray *itemArray = [[NSMutableArray alloc] initWithCapacity:MAX_ICON_POSITION*2];

	for (UIView *view in iconViews) {
		//! Loop over all the iconViews, set up long press gesture recognizer
		if ([view class] == [ToolsIconView class]) {
			ToolsIconView *toolView = (ToolsIconView *)view;
			NSLog(@"%@ - %d", toolView.toolLabel.text, toolView.toolIconButton.tag);
			NSString *tagString = [NSString stringWithFormat:@"%d",toolView.toolIconButton.tag];
			addIcon(@"tool_calendar_JAN.png",toolView.toolLabel.text,tagString)
		}			
	}
	
	return itemArray;
	
}

- (void) setupIconCollisionMatrix
//! Create linear array of icon positions, and bounding circles to test for collision
{
/***
	// Loop over all subviews (icons) and stuff into ordered array
	iconViews = [[[NSMutableArray alloc] initWithCapacity:16] retain];
	for (UIView *view in [self.view subviews]) {
		if (view.tag != 99) {
			[iconViews addObject:view];
		}
	}
	
	// Build static matix (linear array) of icon positions and bounding circles
#define cpv(x,y) CGPointMake(x,y)
	int num = MAX_ICON_POSITION, xl=51, xm=156, xr=261, yt=57, ym=169, yb=273;
	CGPoint verts[] = {
		cpv(xl,yt), cpv(xm,yt), cpv(xr,yt),
		cpv(xl,ym), cpv(xm,ym), cpv(xr,ym),
		cpv(xl,yb), cpv(xm,yb), cpv(xr,yb),
	};
	
	// Stuff verts into global
	for (int j=0; j<num; j++) {
		iconVerts[j] = verts[j];		
	}
	
	// Loop over all icon views & move to position as per the vert matrix
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if (i<num) {
			NSLog(@"view.tag=%d (%.2f,%.2f)",view.tag,iconVerts[i].x,iconVerts[i].y);
			view.center = CGPointMake(iconVerts[i].x,iconVerts[i].y);
		}
	}
	
	isIconAnimating = NO;		// Flag to signal animation
***/
}


- (void) mainLoop:(NSTimer *)timer {
	//! The game's mainLoop, an NSTimer selector. Wait for player to place piece on the board, when the
	
	// Check if we're still animating icon position move, return
	if (isIconAnimating) {
		return;
	}
	
	// First check collision status
	int iconInsertPosition = [self checkIconCollision:25.0];
	if (iconInsertPosition) {
		NSLog(@"position=%d",iconInsertPosition);
		isIconAnimating = YES;
		[self animateIconInsertPosition:iconInsertPosition];
		return;
	}
	
	
	[self showFPS:(GetCurrentTime()-startTime)];
	startTime = GetCurrentTime();
}

- (int) checkIconCollision:(float)dist
//! Check the icon matrix to see if any have been displaced, return index (+1)
{
#define	testPointInCircle(p1,p2,r1) (sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)) <= (r1))

	if (!isUserMovingIcons) {
		// Animation done
		return 0;
	}
	
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] == [ToolsIconView class]) {
			CGPoint p1 = toolButtonSelected.center;
			CGPoint p2 = cpv(iconVerts[i].x,iconVerts[i].y);
			int test = testPointInCircle(p1,p2,dist);
			if (test) {
				NSLog(@"checkIconCollision: [%d] view.tag=%d state=%@ dist=%.2f",i,view.tag,(test?@"IN":@"OUT"),sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)));
				return i+1;
			}
		}
	}
	
	return 0;
}

- (void) animateIconInsertPosition:(int)position
//! Start animation sequence to insert icon into view matrix at new position
{
	// Remove icon from old position
	if (toolButtonSelectedIndex) {
		NSLog(@"animateIconInsertPosition: remove old NSNull at %d",toolButtonSelectedIndex);
		[iconViews removeObjectAtIndex:toolButtonSelectedIndex-1];
	}
	
	// Insert icon into new position
	NSLog(@"animateIconInsertPosition: insert new NSNull at %d",position);
	[iconViews insertObject:[NSNull null] atIndex:position-1];
	toolButtonSelectedIndex = position;

	// Move icons to new positions
	[UIView beginAnimations:@"MoveIcons" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDone)];
	[UIView setAnimationDuration:0.25];

	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] == [ToolsIconView class]) {
			NSLog(@"animate view.tag=%d (%.2f,%.2f)",view.tag,iconVerts[i].x,iconVerts[i].y);
			view.center = CGPointMake(iconVerts[i].x,iconVerts[i].y);
		}
	}
	
	[UIView commitAnimations];

}

- (void) animationDone
//- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//! Animation completed, start the physic main loop again
{
	NSLog(@"AnimationDone");
	[self listIconOrder];	// diagnostic
	isIconAnimating = NO;
}

- (void) showFPS:(double)dt {
	//! Routine to update & show FPS
	static float frames = 0.0;
	static float totalDt = 0.0;
	
	frames++;
	totalDt += dt;
	if (totalDt > 0.2) {
//		fpsLabel.text = [NSString stringWithFormat:@"%.1f fps",(frames/totalDt)];
		frames = 0.0;
		totalDt = 0.0;
	}
}


- (void) setIconAnimation:(BOOL)isAnimating
{
	//! Attach block-based animation to icons, depending on location (order)
	if (!isAnimating) {
		// Animation done
		return;
	}
	
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		if ([view class] == [ToolsIconView class]) {
			// Loop over all icon views, add "dancing" animation to each
#define kAnimationRotateDeg 6.0
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 2.0
			[UIView animateWithDuration:0.25 
								delay:0.0 
							  options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat 
						   animations:^{
							   view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, kAnimationTranslateX, kAnimationTranslateY);
							   view.transform = CGAffineTransformMakeRotation(kAnimationRotateDeg*(i%2 ? -1 : +1)*(3.141519/180.0));
						   }
						   completion:^(BOOL finished){
							   [UIView animateWithDuration:0.25
													 delay: 0.0
												   options: UIViewAnimationOptionAllowUserInteraction
												animations:^{
													view.transform = CGAffineTransformTranslate(view.transform, -kAnimationTranslateX, -kAnimationTranslateY);
													view.transform = CGAffineTransformMakeRotation(-kAnimationRotateDeg*(i%2 ? +1 : -1)*(3.141519/180.0));
												}
												completion:nil];							   
						   }];

		}
	}
		
	//[UIView commitAnimations];
}


#pragma mark UITouch & UIGesture Methods

- (IBAction) doToolButton:(id)sender {
	NSLog(@"doToolButton down");
}

- (void) longPressDetected:(UIGestureRecognizer *)gestureRecognizer {
	//! Method to handle long presses on view
	if (isUserMovingIcons) {
		// User already moving so do nothing
		return;
	}
	
	for (int i=0; i<[iconViews count]; i++) {
		UIView *view = [iconViews objectAtIndex:i];
		//! Loop over all the iconViews, find which icon button was pressed, start to move it
		if ([view class] == [ToolsIconView class]) {
			ToolsIconView *toolView = (ToolsIconView *)view;
			if (gestureRecognizer.view == toolView.toolIconButton) {
				NSLog(@"longPressDetected: toolButtonSelected");
				toolButtonSelectedIndex = i+1;	// 1 offset on index, visual reference
				[self setIconAnimation:TRUE];
				isUserMovingIcons = YES;
				toolView.hidden = YES;		
				
				toolButtonSelected.image = [toolView.toolIconButton imageForState:UIControlStateNormal];
				toolButtonSelected.center = toolView.center;
				[self.view bringSubviewToFront:toolButtonSelected];
				[UIView beginAnimations:@"RevealToolButtonSelected" context:NULL];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(animationDone)];
				[UIView setAnimationDuration:0.25];
				toolButtonSelected.hidden = NO;
				CGAffineTransform transform = CGAffineTransformMakeScale(1.5,1.5);
				toolButtonSelected.transform = transform;
				[UIView commitAnimations];
				
				// Save selected iconView, replace it with NSNull in view array
				selectedIconView = toolView;
				[iconViews replaceObjectAtIndex:i withObject:[NSNull null]];

			}
		}
	}
}


- (void) setupGestureRecognition {
	// Attached UIGesture recognizers to the timeLineView
	UILongPressGestureRecognizer *recognizer;
	
	for (UIView *view in iconViews) {
		//! Loop over all the iconViews, set up long press gesture recognizer
		if ([view class] == [ToolsIconView class]) {
			ToolsIconView *toolView = (ToolsIconView *)view;
			
			recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
			recognizer.minimumPressDuration = 1.0f;	// default is 0.4f
			[toolView.toolIconButton addGestureRecognizer:recognizer];
			recognizer.delegate = self;
//			[recognizer release];
			
		}
	}
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	
    // If gesture was within bounds of iconView button then allow
	for (UIView *view in iconViews) {
		//! Loop over all the iconView, determine if a long press occured within a button
		if ([view class] == [ToolsIconView class]) {
			// Make sure it's not a NSNull class
			ToolsIconView *toolView = (ToolsIconView *)view;
			if (touch.view == toolView.toolIconButton) {
				return YES;
			}
		}
	}
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	NSLog(@"touchesBegan: toolButtonSelectedIndex=%d",toolButtonSelectedIndex);
	
	//UITouch *touch = [touches anyObject];	
	//CGPoint location = [touch locationInView: [touch view]];
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	NSLog(@"touchesMoved: toolButtonSelectedIndex=%d",toolButtonSelectedIndex);
	
	UITouch *touch = [touches anyObject];	
	CGPoint location = [touch locationInView:self.view];
		
	if ([touch view] == toolButtonSelected) {
		toolButtonSelected.center = CGPointMake(location.x, location.y);	// 47 = height of navigation bar
		//NSLog(@"touchesMoved: toolButtonSelected (%2.f, %2.f)", location.x, location.y);
	}
	
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//! Respond to touches. Move a uiview if it's being touched
{
	NSLog(@"touchesEnded: toolButtonSelectedIndex=%d",toolButtonSelectedIndex);
	
	UITouch *touch = [touches anyObject];	
	//CGPoint location = [touch locationInView: [touch view]];
	
	if ([touch view] == toolButtonSelected) {
		// Change back to dynamic shape
		NSLog(@"touchesEnded: toolButtonSelected");
		isUserMovingIcons = NO;
		CGAffineTransform transform = CGAffineTransformMakeScale(1.0,1.0);
		toolButtonSelected.transform = transform;
		toolButtonSelected.hidden = YES;

		// Save selected iconView, replace NSNull in view array
		selectedIconView.center = iconVerts[toolButtonSelectedIndex-1];
		[iconViews replaceObjectAtIndex:toolButtonSelectedIndex-1 withObject:selectedIconView];

		for (int i=0; i<[iconViews count]; i++) {
			UIView *view = [iconViews objectAtIndex:i];
			if ([view class] == [ToolsIconView class]) {
				// Loop over all icon views, remove "dancing" animation to each
				[UIView animateWithDuration:0.2 
									  delay:0.0 
									options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 view.alpha = 1.0;
									 view.hidden = NO;
									 view.transform = CGAffineTransformIdentity;	
								 }
								 completion:^(BOOL finished){
									 view.transform = CGAffineTransformIdentity;	
								 }];
			}
		}
				
		[self listIconOrder];

		//if([delegate respondsToSelector:@selector(openSringBoardDidReorderIcons:iconArray:)]) {
		//	[delegate openSringBoardDidReorderIcons:self iconArray:[self createOrderedIconDictionaryArray]];
		//}
		
	}
}

#pragma mark -
#pragma mark Scrollview delegate



- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    if (pageControlIsChangingPage)
        return;
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
    pageControlIsChangingPage = NO;
}
	

@end
