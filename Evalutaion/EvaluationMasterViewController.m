//
//  EvaluationMasterViewController.m
//  Evalutaion
//
//  Created by Victor Valle Juarranz on 24/02/13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import "EvaluationMasterViewController.h"

#import "Draw2ViewController.h"
#import "OpenSpringBoardVC.h"
#import "OSCManager.h"
#import "OSCOutPort.h"

@interface EvaluationMasterViewController()

- (void)sendOSCMessageTime:(NSInteger)time
                    errors:(NSInteger)errors
             gestureErrors:(NSInteger)gestureErrors
                 appNumber:(NSInteger)appNumber;

@end

@implementation EvaluationMasterViewController

@synthesize octopocusButton;
@synthesize desktopButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
 
    manager = [[OSCManager alloc] init];
    [manager setDelegate:self];
    
    [manager createNewInputForPort:8888];
    
    outPort = [manager createNewOutputToAddress:@"127.0.0.1" atPort:1234];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)octopocusButtonTapped {
   
   if (draw2ViewController == nil) {
   
       draw2ViewController = [[Draw2ViewController alloc] initWithNibName:@"Draw2ViewController"
                                                                           bundle:nil];
       [draw2ViewController setDelegate:self];
   
   }
   
   [self.navigationController pushViewController:draw2ViewController animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (IBAction)desktopButtonTapped {
    
    if (openSpringBoardVC == nil) {
        
        openSpringBoardVC = [[OpenSpringBoardVC alloc] initWithNibName:@"OpenSpringBoardVC"
                                                                    bundle:nil];
        [openSpringBoardVC setDelegate:self];
    }
    
    [self.navigationController pushViewController:openSpringBoardVC animated:YES];
    
    
}


#pragma mark -
#pragma mark OSC Delegate

// called by delegate on message
- (void) receivedOSCMessage:(OSCMessage *)m {
    NSArray* args = [m valueArray];
    NSString* address = [[args objectAtIndex:0] stringValue];
    // test what kind of experiment component is starting (or ending)
    if ([address isEqualToString:@"/touchstone/experiment/start"]) {
    // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/experiment/end"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/intertitle/start"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/intertitle/end"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/block/start"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/block/end"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/trial/start"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/trial/end"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else if ([address isEqualToString:@"/touchstone/endcondition"]) {
        // retrieve attached arguments from the message (factor values for example)
    } else {
        NSLog(@"OSC Message not recognized");
    }
}

#pragma mark -
#pragma mark Functions

- (void)sendOSCMessageTime:(NSInteger)time
                    errors:(NSInteger)errors
             gestureErrors:(NSInteger)gestureErrors
                 appNumber:(NSInteger)appNumber {

    // make an OSC message
    OSCMessage *newMsg = [OSCMessage createWithAddress:@"/touchstone/experiment/endcondition"];
   
    // attach arguments to the message (measure values for example) [newMsg addInt:1]; // HitDistractor measure value
    [newMsg addInt:time]; // Time value
    [newMsg addInt:errors]; // Time value
    [newMsg addInt:gestureErrors]; // Time value
    [newMsg addInt:appNumber]; // Time value
   
    // send the OSC message
    [outPort sendThisMessage:newMsg];
    

}

#pragma mark -
#pragma mark Draw2ViewControllerDelegate

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
                         app:(NSInteger)app {
    
    [self sendOSCMessageTime:time
                      errors:errors
               gestureErrors:gestureErrors
                   appNumber:app];

}

#pragma mark -
#pragma mark OpenSpringBoardVCDelegate

/**
 * Communicates the user performance
 *
 * @param time The time
 * @param errors The errors
 * @param app The app number
 */
- (void)measusesObtainedTime:(NSInteger)time
                      errors:(NSInteger)errors
                         app:(NSInteger)app {
    
    [self sendOSCMessageTime:time
                      errors:errors
               gestureErrors:0
                   appNumber:app];
    
}


@end
