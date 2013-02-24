//
//  OpenSpringBoard.h
//  ScrollTests
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsIconView.h"


#define MAX_ICON_POSITION 16

@protocol OpenSpringBoardDelegate;


@interface OpenSpringBoard : UIViewController  <UIGestureRecognizerDelegate,UIScrollViewDelegate> {
	
	IBOutlet UIImageView	*toolButtonSelected;
	
	NSTimer *mainLoopTimer;
	double startTime;
//	IBOutlet UILabel *fpsLabel;
	
	NSMutableArray *iconViews;									//!< Ordered array of icon views
	IBOutlet ToolsIconView *toolIconView;						//!< IBFactory for standard icon view container
	ToolsIconView *selectedIconView;							//!< Placeholder for selected icon view  
	CGPoint iconVerts[MAX_ICON_POSITION];						//!< Ordered array of icon positions (cpv)
	int maxIconPerPage;											//!< Max number of icons shown per page
	BOOL isIconAnimating;										//!< State flag, indicates icons moving
	int toolButtonSelectedIndex;									//!< Index of selected (moving) icon +1
	
	BOOL isUserMovingIcons;										//!< Enter icon move mode, make icons dance!
	
//	id <OpenSpringBoardDelegate> delegate;						//!< Delegate declaration
    /**
     * Delegate
     */
    id<OpenSpringBoardDelegate>__weak delegate;
    
    IBOutlet UIPageControl	*pageControl;                       //!< page control for list of tools views
	IBOutlet UIScrollView	*scrollView;                        //!< scroll view control for collection of tools views
	IBOutlet UIView *pageOne, *pageTwo, *pageThree,*pageFour;//, *pageFive;                         //!< pages under control of the scrollView / pageControl
	BOOL pageControlUsed;                                       //!< flag to store UI state

    BOOL pageControlIsChangingPage;

}
//@property (nonatomic,assign) id <OpenSpringBoardDelegate> delegate;
@property (nonatomic, readwrite, weak) id<OpenSpringBoardDelegate> delegate;

- (IBAction) doToolButton:(id)sender;

- (void) buildIconViews;
- (IBAction) launchTool:(id)sender;
- (void) listIconOrder;
- (NSMutableArray *) createOrderedIconDictionaryArray;

- (void) mainLoop:(NSTimer *)timer;
- (void) showFPS:(double)dt;
- (void) setupIconCollisionMatrix;
- (int) checkIconCollision:(float)dist;
- (void) animateIconInsertPosition:(int)position;
- (void) animationDone;
- (void) setupGestureRecognition;

- (void) setIconAnimation:(BOOL)isAnimating;

@end

@protocol OpenSpringBoardDelegate <NSObject>
@required
- (NSMutableArray *) openSringBoardLoadIconArray:(OpenSpringBoard *)openSringBoardVC iconPageLimit:(int *)numIcons;
@optional
- (void) openSringBoardIconPress:(OpenSpringBoard *)openSringBoardVC iconSelectedTag:(int)iconTag;
- (void) openSringBoardDidReorderIcons:(OpenSpringBoard *)openSringBoardVC iconArray:(NSMutableArray *)iconArray;
- (void) openSringBoardVC:(OpenSpringBoard *)openSringBoardVC iconDeletedTag:(int)iconTag;
- (void) setIconTag:(int)tag badgeText:(NSString *)badgeText; // should this be a callback or an interface method?
@end

