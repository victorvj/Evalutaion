//
//  Draw2ViewController.h
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "Gesture.h"
#import "RecordViewController.h"
#import "RemoveGestureViewController.h"
#import "Vector.h"
//#import <VVOSC/VVOSC.h>

@protocol Draw2ViewControllerDelegate

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
               gestureErrors:(NSInteger)gestureErrors
                         app:(NSInteger)app;

@end


@interface Draw2ViewController : UIViewController <DrawViewDelegate, RecordViewControllerDelegate, RemoveGestureViewControllerDelegate> {
    
    /*
     * The draw view
     */
	IBOutlet DrawView *viewDraw;
    
    /*
     * Mode switch
     */
    UISegmentedControl *modeSwitch_;
    
    /**
     * Options button
     */
    UIButton *optionsButton;
    
    /*
     * The users gesture to compare with possible gestures
     */
    NSMutableArray *userGesture;
    
    /*
     * The array of Predefined Gestures: where we store the predefined gestures. Defined in the view did load
     */
    NSMutableArray *predefinedGestureArray;
    
    /*
     * The array of drawable gestures: where we store the possible gestures that can be drawn. It is updated after every touch update.
     */
    NSMutableArray *drawableGesturesArray;
    
    /*
     * User to template distance
     */
    Vector *userToTemplateDistance;
    
    /*
     * Record View Controller
     */
    RecordViewController *recordViewController;
    
    /**
     * Remove Gesture View Controller
     */
    RemoveGestureViewController *removeGestureViewController;
    
    /**
     * Guide gestures array
     */
    NSMutableArray *guideGesturesArray;
    
    /**
     * Timer
     */
    double timer;
    
    /**
     * Expert mode
     */
    BOOL expertMode;
    
    /**
     * The final Gesture
     */
    Gesture *finalGesture;
    
    /**
     * Delegate
     */
    id<Draw2ViewControllerDelegate>__weak delegate;
    
    
    NSDate *initDate;
    NSInteger errorsCount;
    NSInteger gestureErrorsCount;
    NSInteger appToOpen;
}

/**
 * Defines the viewDraw and exports it to the IB
 */
@property (nonatomic, readwrite, strong) IBOutlet DrawView *viewDraw;

/**
 * Defines the optionsButton and exports it to the IB
 */
@property (nonatomic, readwrite, strong) IBOutlet UIButton *optionsButton;

/**
 * Defines the modeSwitch and exports it to the IB
 */
@property (nonatomic, readwrite, strong) IBOutlet UISegmentedControl *modeSwitch;

/*
 * Delegate
 */
@property (nonatomic, readwrite, weak) id<Draw2ViewControllerDelegate> delegate;

/*
 * Delegate
 */
@property (nonatomic) NSInteger appToOpen;

/**
 * Mode switch 
 */
-(IBAction)modeSwitchAction;

/**
 * Options
 */
-(IBAction)optionsTapped;

@end

