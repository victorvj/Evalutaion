//
//  Draw2ViewController.m
//  Draw2
//
//  Created by Hybrid Interaction on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Draw2ViewController.h"

#import "Application.h"
#import "Color.h"
#import "Constants.h"
#import "Dot.h"
#import "Gesture.h"
#import "RecordViewController.h"
#import "Tools.h"
#import "Vector.h"

#import <QuartzCore/QuartzCore.h>
//#import <VVOSC/VVOSC.h>

@interface Draw2ViewController ()

/**
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 *
 * @param dot1
 * @param dot1
 * @return TRUE if distance between dot1 and dot2 is =< ERROR_DISTANCE. False otherwise
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1
                      andDot2:(Dot *)dot2;


/**
 * Brings the gesture to star in the user touch
 *
 * @param gesture The array of dots
 * @param dot The reference dot
 * @return The gesture translated
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture
                           toDot:(Dot *)dot;

/**
 * Brings the gesture to star in the user touch
 *
 * @param gesture The array of dots
 * @param dot The reference dot
 * @param position The position of the reference dot in gesture
 * @return The gesture translated
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture
                           toDot:(Dot *)dot
                     forPosition:(NSInteger)position;


/**
 * Determines if a Dot could be part of a gesture given a position in the gesture array
 *
 * @param dot The dot to check
 * @param gesture The gesture
 * @param position The reference position of the dot inside the gesture
 * @result YES if dot is the allowed distance and 
 */
- (BOOL)isPossibleDot:(Dot *)dot
            inGesture:(NSArray *)gesture
          forPosition:(NSInteger)position;


/**
 * Samples the line between the last dot in the user gesture and the touch
 *
 * @param dot The touch dot
 */
- (void)samplingDotsToNewTouch:(Dot *)dot;

/**
 * Updates the drawable gestures
 */
- (void)updateDrawableGestures;

/**
 * Clean
 */
-(void)clean;

/**
 * Calculates the thickness based on the distance error
 */
- (CGFloat)thicknessByDistance:(CGFloat)distance;

/**
 * Determines if a gesture is a subgesture of the already recorded gestures
 */
- (BOOL)isGestureSubpathOfOtherGesture:(NSArray *)gesture;

@end

#pragma mark -

@implementation Draw2ViewController

#pragma mark -
#pragma mark Properties

@synthesize viewDraw;
@synthesize modeSwitch = modeSwitch_;
@synthesize optionsButton;
@synthesize delegate;
@synthesize appToOpen;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {
    
    userGesture = nil;
    
    predefinedGestureArray = nil;
    
    drawableGesturesArray = nil;
    
    userToTemplateDistance = nil;
    
    
    recordViewController = nil;
    
    removeGestureViewController = nil;
    
    guideGesturesArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIApplicationDidBecomeActiveNotification];
    
}

#pragma mark -
#pragma mark View life cycle

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 * Called after the controller’s view is loaded into memory.
 */
 - (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
     
    predefinedGestureArray = [[NSMutableArray alloc] init];
    
    userGesture = [[NSMutableArray alloc] init];
    drawableGesturesArray = [[NSMutableArray alloc] init];
    guideGesturesArray = [[NSMutableArray alloc] init];
     
#if DEBUGGING_MODE
     optionsButton.layer.cornerRadius = 5.0;
     optionsButton.layer.masksToBounds = YES;
     optionsButton.hidden = NO;
     modeSwitch_.hidden = NO;
     appToOpenImage.hidden = YES;
     
#else
     optionsButton.hidden = YES;
     modeSwitch_.hidden = YES;
     appToOpenImage.hidden = NO;
     appToOpenImage.image = [UIImage imageNamed:@"Phone.jpg"];
//     appToOpenImage.contentMode = UIViewContentModeScaleAspectFit;
     appToOpenImage.backgroundColor = [UIColor redColor];
     
#endif
     
     initDate = [NSDate date];
     errorsCount = 0;
     gestureErrorsCount = 0;
    
}

/**
 * Notifies the view controller that its view is about to be added to a view hierarchy.
 * 
 * @param animated If YES, the view is being added to the window using an animation.
 */
-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clean)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [super viewWillAppear:animated];
    [self modeSwitch];
    viewDraw.delegate = self;
    [viewDraw setBackgroundColor:[UIColor whiteColor]];
    
    [optionsButton setEnabled:([predefinedGestureArray count] > 0)];
}

/**
 * Notifies the view controller that its view is about to be removed from a view hierarchy.
 */
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark DrawViewDelegate

/*
 * Gets Point from the view and checks if it is in the gesture
 */
- (void)userTouch:(Dot *)touch isFirst:(BOOL)first {
    //calculate distance to last saved point

    // n gestures algorithm
    
    if (first) {
        
        timer = CFAbsoluteTimeGetCurrent();
        expertMode = NO;
        
        // Cleans the arrays
        [drawableGesturesArray removeAllObjects];
        [userGesture removeAllObjects];
        [guideGesturesArray removeAllObjects];
        
        // Inits the userGesture with the first dot
        [userGesture addObject:touch];
        
        // Brings all the predefined gestures to the user first tap and they fit in the screen they will
        // be stored in the drawableGesturesArray
        for (Gesture *gesture in predefinedGestureArray) {
            
            NSArray *gestureToCheck = [NSArray arrayWithArray:[gesture gesture]];
            NSArray *array = [self bringPosibleGesture:gestureToCheck toDot:touch];
            
            CGRect frame = [[self view] frame];

            if ([Tools gestureFitsOnScreen:array inRect:&frame]) {
            
                Gesture *gestureMoved = [[Gesture alloc] init];
                [gestureMoved setApp:[gesture app]];
                [gestureMoved setColor:[gesture color]];
                [gestureMoved setGesture:[[NSArray alloc] initWithArray:array]];
                [gestureMoved setThickness:GESTURE_THICKNESS];
                
                [drawableGesturesArray addObject:gestureMoved];
                [guideGesturesArray addObject:gestureMoved];
            }
            
        }
        
        // Updates the interface
        [self updateDrawableGestures];
        
    } else {
        
        double currentTime = CFAbsoluteTimeGetCurrent();
        double difference = currentTime - timer;
        
        timer = currentTime;
        
        expertMode = NO;

        if ((difference < EXPERT_TIME) && ([modeSwitch_ selectedSegmentIndex] == 0) ) {
        
            expertMode = YES;
            
        }
        
        gestureErrorsCount ++;

        // From the drawableGestures we have to see which one of them are still possible to draw
        [self samplingDotsToNewTouch:touch];
    
    }
}

/**
 * End recording the new gesture
 */
- (void)endRecordingNewGesture {

    if ([self isGestureSubpathOfOtherGesture:userGesture]) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The gesture you are trying to record is in conflict with another gesture already recorded.\n\n Please, try record a new gesture."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    
    } else {
    
        if ([predefinedGestureArray count] + 1 > 6) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"All applications are assigned to a gesture.\n\n Delete a gesture from Settings before recording a new one."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            
        } else {
        
            if (recordViewController == nil) {
                recordViewController = [[RecordViewController alloc]init];
                recordViewController.delegate = self;
                
            }
            
            [recordViewController setGesturesArray:predefinedGestureArray];
            
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:recordViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
            
        }
        
    }
    
}

/**
 * Recognition finished. Opens the application recorded in the gesuture
 */
- (void)recognitionFinished {

    if (appToOpen == 0) {
        
        NSDate *endDate = [NSDate date];
        NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:initDate];

        NSInteger time = secondsBetween; //TODO: calculate
        
        [delegate measusesObtainedTime:time
                                errors:errorsCount
                         gestureErrors:gestureErrorsCount
                                   app:appToOpen];
        
    } else {
    
        errorsCount++;
        
    }
    
    
//    NSString *schema = [[finalGesture app] schema];
//    
//    NSURL *urlString = [NSURL URLWithString:schema];
//    
//    if (![[UIApplication sharedApplication] canOpenURL:urlString]) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
//                                                        message:@"Your device can't open this application."
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    } else {
//    
//        [[UIApplication sharedApplication] openURL:urlString];
//        
//    }
    
}

#pragma mark -
#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    [self clean];

}

#pragma mark -
#pragma mark RecordViewControllerDelegate

/**
 * Record gesture
 */
- (void)recordGestureWithColor:(Color *)color applicationName:(Application *)appName {

    if (appName != nil) {
        
        Gesture *gestureToSave = [[Gesture alloc] init];
        [gestureToSave setApp:appName];
        [gestureToSave setColor:color];
        [gestureToSave setGesture:[NSArray arrayWithArray:userGesture]];
        [gestureToSave setThickness:GESTURE_THICKNESS];
        
        [predefinedGestureArray addObject:gestureToSave];

    }
    
    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    [optionsButton setEnabled:([drawableGesturesArray count] > 0)];

}

#pragma mark -
#pragma mark RemoveGestureViewControllerDelegate

/**
 * Gestures remove result transmits the array of gestures that will stay
 *
 * @param array The array of gestures
 */
- (void)gesturesRemovedResult:(NSArray *)array {

    if (array != nil) {
        
        [predefinedGestureArray removeAllObjects];
        [predefinedGestureArray addObjectsFromArray:array];
        
    }
    
    [optionsButton setEnabled:([predefinedGestureArray count] > 0)];

}

#pragma mark -
#pragma mark Other methods

/*
 * Checks if the distante between dot1 and dot2 is bigger than the ERROR_DISTANCE
 */
- (BOOL)checkErrorBetweenDot1:(Dot *)dot1 andDot2:(Dot *)dot2 {
    
    Dot *transDot = [[Dot alloc] init];
    transDot.x = dot1.x + userToTemplateDistance.x;
    transDot.y = dot1.y + userToTemplateDistance.y;

    CGFloat transToTempDistance = fabsf([Tools distanceBetweenPoint:transDot andPoint:dot2]);

    return transToTempDistance > ERROR_DISTANCE;

}

/*
 * Brings the gesture to star in the user touch
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture toDot:(Dot *)dot {

    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    Dot *firstDotInGesture = [gesture objectAtIndex:0];
    
    NSInteger gestureCount = [gesture count];
    NSInteger i = 1;
    
    [result addObject:dot];
    
    while (i < gestureCount) {
        
        Dot *translatedDot = [Tools transformFromDot:[gesture objectAtIndex:i] givenDot1:firstDotInGesture dot2:dot];
        
        [result addObject:translatedDot];
        
        i++;
    
    }
    
    return result;

}

/*
 * Brings the gesture to star in the user touch
 */
- (NSArray *)bringPosibleGesture:(NSArray *)gesture toDot:(Dot *)dot forPosition:(NSInteger)position {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    Dot *dotInGesture = [gesture objectAtIndex:position];
    
    NSInteger gestureCount = [gesture count];
    NSInteger i = 0;
        
    while (i < gestureCount) {
        
        Dot *translatedDot = [Tools transformFromDot:[gesture objectAtIndex:i] givenDot1:dotInGesture dot2:dot];
        
        [result addObject:translatedDot];
        
        i++;
        
    }
    
    return result;
    
}

/*
 * Determines if a Dot could be part of a gesture given a position in the gesture array
 */
- (BOOL)isPossibleDot:(Dot *)dot
            inGesture:(NSArray *)gesture
          forPosition:(NSInteger)position {

    BOOL result = NO;
    
    if (position >= [gesture count]) {
        
//        NSLog(@"YOU SHOULD HAVE ALREADY RECOGNIZED THE GESTURE");
        
    } else {
    
        Dot *dotInGesture = [gesture objectAtIndex:position];
        
        CGFloat distance = [Tools distanceBetweenPoint:dot andPoint:dotInGesture];
        result = (distance <= ERROR_DISTANCE);
        
    }
    
    return result;

}

/*
 * Samples the line between the last dot in the user gesture and the touch
 */
- (void)samplingDotsToNewTouch:(Dot *)dot {
    
    CGFloat distance = [Tools distanceBetweenPoint:[userGesture lastObject] andPoint:dot];
    
    if (distance ==  SAMPLING_DISTANCE) {
        
        [userGesture addObject:dot];
        [self updateDrawableGestures];
        
    } else if (distance > SAMPLING_DISTANCE) {
        
        NSInteger chunks = (int)(distance / SAMPLING_DISTANCE);
        NSInteger i = 0;
        BOOL isError = NO;
        
        while (i < chunks && !isError) {
            
            Dot *sampleDot = [Tools dotInConstantDistanceFromDot:[userGesture lastObject] toDot:dot];
                        
            [userGesture addObject:sampleDot];
            
            [self updateDrawableGestures];
            
            i++;
            
        }
                
    }

}

/*
 * Updates the drawable gestures
 */
- (void)updateDrawableGestures {

    if (modeSwitch_.selectedSegmentIndex == 0) {
    
        NSMutableArray *auxDrawableGesturesArray = [[NSMutableArray alloc] init];
        NSMutableArray *auxGuideGesturesArray = [[NSMutableArray alloc] init];

        Dot *lastDot = [userGesture lastObject];

        for (Gesture *gesture in guideGesturesArray) {//drawableGesturesArray) {
            
            NSArray *array = [gesture gesture];
            
            
            if ([self isPossibleDot:lastDot inGesture:array forPosition:([userGesture count] - 1)]) {
                
                [auxGuideGesturesArray addObject:gesture];
                
                NSArray *gestureToCheck = [NSArray arrayWithArray:[gesture gesture]];
                NSArray *array = [self bringPosibleGesture:gestureToCheck
                                                     toDot:lastDot
                                               forPosition:([userGesture count] - 1)];
                                
                Gesture *gestureMoved = [[Gesture alloc] init];
                [gestureMoved setApp:[gesture app]];
                [gestureMoved setColor:[gesture color]];
                [gestureMoved setGesture:[[NSArray alloc] initWithArray:array]];
                
                CGFloat distance = [Tools distanceBetweenPoint:lastDot
                                                      andPoint:[gestureToCheck objectAtIndex:([userGesture count] - 1)]];
                
                CGFloat thickness = [self thicknessByDistance:distance];
                
                [gestureMoved setThickness:thickness];

                [auxDrawableGesturesArray addObject:gestureMoved];
                
            } else {
                
                // The gesture is discarded
            }
            
        }
        
        [guideGesturesArray removeAllObjects];
        [guideGesturesArray addObjectsFromArray:auxGuideGesturesArray];

        [drawableGesturesArray removeAllObjects];
        [drawableGesturesArray addObjectsFromArray:auxDrawableGesturesArray];
        
        
        // Sends to print the getures
        

    
        if ([drawableGesturesArray count] == 1) {
            
            if (finalGesture != nil) {
            
                finalGesture = nil;
                
            }
            
            finalGesture = [[Gesture alloc] init];
            
            Gesture *auxGest = [drawableGesturesArray objectAtIndex:0];
            
            [finalGesture setColor:[auxGest color]];
            [finalGesture setApp:[auxGest app]];
            [finalGesture setGesture:[auxGest gesture]];
            [finalGesture setThickness:[auxGest thickness]];
                                    
            
            if ([[auxGest gesture] count] == [userGesture count]) {
                
                viewDraw.finishRecognizing = YES;
                
            }
            
        }
        
        if ([drawableGesturesArray count] > 0) {
            
            [viewDraw drawUserGesture:userGesture forPossibleGesutures:drawableGesturesArray expertMode:expertMode];
            
        } else {
        
            [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
        
        }

    } else {
        
        [viewDraw drawUserGesture:userGesture forPossibleGesutures:nil expertMode:expertMode];
        
    }
    
    
}

/**
 * Clean
 */
-(void)clean {

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];

}

/*
 * Mode switch
 */
-(IBAction)modeSwitchAction {

    viewDraw.recording = (modeSwitch_.selectedSegmentIndex == 1);
    viewDraw.recognizing = (modeSwitch_.selectedSegmentIndex == 0);

    [viewDraw drawUserGesture:nil forPossibleGesutures:nil expertMode:expertMode];
    
}

/**
 * Options
 */
-(IBAction)optionsTapped {

    if (removeGestureViewController != nil) {
        
        removeGestureViewController = nil;
    }
    
    
    removeGestureViewController = [[RemoveGestureViewController alloc] init];
    removeGestureViewController.delegate = self;
    
    [removeGestureViewController setGesturesArray:predefinedGestureArray];

    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:removeGestureViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
    
}

/**
 * Calculates the thickness based on the distance error
 */
- (CGFloat)thicknessByDistance:(CGFloat)distance {
    
    CGFloat result = GESTURE_THICKNESS;
    
    CGFloat error = ERROR_DISTANCE;
    CGFloat sample = (error / 10.0f);
    
    if (distance > ERROR_DISTANCE) {
        result = 0.0f;
    } else if (distance > (sample * 8)) {
        result = (result/5)*1;
    } else if (distance > (sample * 6)) {
        result = (result/5)*3;
    } else if (distance > (sample * 4)) {
        result = (result/5)*3;
    } else if (distance > (sample * 2)) {
        result = (result/5)*4;
    }
    
    return result;
    
}

/**
 * Determines if a gesture is a subgesture of the already recorded gestures
 */
- (BOOL)isGestureSubpathOfOtherGesture:(NSArray *)gesture {

    BOOL result = NO;
    
    if ([guideGesturesArray count] > 0) {
    
        NSInteger j = 0;
        
        while (j < [guideGesturesArray count] && !result) {
            
            Gesture *parentGesture = [guideGesturesArray objectAtIndex:j];
            
            NSInteger smallerCount = 0;
            
            NSArray *parentGestureArray = [parentGesture gesture];
            
            if ([parentGestureArray count] > [gesture count]) {
                smallerCount = [gesture count];
            } else {
                smallerCount = [parentGestureArray count];
            }
            
            NSInteger i = 0;
            NSArray *auxGesture = [self bringPosibleGesture:gesture toDot:[parentGestureArray objectAtIndex:0]];
            BOOL previousPointsAreNear = YES;
            
            while (i < smallerCount && previousPointsAreNear) {
                
                CGFloat distance = [Tools distanceBetweenPoint:[auxGesture objectAtIndex:i] andPoint:[parentGestureArray objectAtIndex:i]];
                
                CGFloat referenceDistance = SAMPLING_DISTANCE * 1.5f;
                
                previousPointsAreNear = (distance < referenceDistance);

                i++;
                
            }
            
            if (i == smallerCount && previousPointsAreNear) {
                result = YES;
            }
            
            j++;
            
        }
    
    
    }
    
    return result;

}

#pragma mark -
#pragma mark OSC Delegate

//// called by delegate on message
//- (void) receivedOSCMessage:(OSCMessage *)m {
//    NSArray* args = [m valueArray];
//    NSString* address = [[args objectAtIndex:0] stringValue];
//    // test what kind of experiment component is starting (or ending)
//    if ([address isEqualToString:@"/touchstone/experiment/start"]) {
//    // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/experiment/end"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/intertitle/start"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/intertitle/end"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/block/start"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/block/end"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/trial/start"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/trial/end"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else if ([address isEqualToString:@"/touchstone/endcondition"]) {
//        // retrieve attached arguments from the message (factor values for example)
//    } else {
//        NSLog(@"OSC Message not recognized");
//    }
//}



@end
