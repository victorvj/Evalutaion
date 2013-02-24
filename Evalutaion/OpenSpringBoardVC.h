//
//  OpenSpringBoardVC.h
//  openspringboard
//
//  Created by Mobile Flow LLC on 2/21/11.
//  Copyright 2011 Mobile Flow LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenSpringBoard.h"
//#import <VVOSC/VVOSC.h>

@protocol OpenSpringBoardVCDelegate

/**
 * Communicates the user performance
 *
 * @param time The time
 * @param errors The errors
 * @param gestureErrors The gesture Errors
 * @param app The app number
 */
- (void)measusesObtainedTime:(NSInteger)time
                      errors:(NSInteger)errors
                         app:(NSInteger)app;

@end

@interface OpenSpringBoardVC : UIViewController <OpenSpringBoardDelegate> {

	OpenSpringBoard *_openSpringBoard;
	
	NSMutableArray *itemArray;						//!< Array to store the icon information & order

    /**
     * Delegate
     */
    id<OpenSpringBoardVCDelegate>__weak delegate;
    
    
    NSDate *initDate;
    NSInteger errorsCount;
    NSInteger appToOpen;
	
}
@property (nonatomic,retain) OpenSpringBoard *openSpringBoard;

/*
 * Delegate
 */
@property (nonatomic, readwrite, weak) id<OpenSpringBoardVCDelegate> delegate;

/*
 * Delegate
 */
@property (nonatomic) NSInteger appToOpen;

@end
