//
//  EvaluationMasterViewController.h
//  Evalutaion
//
//  Created by Victor Valle Juarranz on 24/02/13.
//  Copyright (c) 2013 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draw2ViewController.h"
#import "OpenSpringBoardVC.h"

@class Draw2ViewController;
@class OpenSpringBoardVC;
@class OSCManager;
@class OSCOutPort;

@interface EvaluationMasterViewController : UIViewController <Draw2ViewControllerDelegate, OpenSpringBoardVCDelegate> {

    UIButton *octopocusButton;
    UIButton *desktopButton;
    
    UILabel *intertitleLabel;
    
    Draw2ViewController *draw2ViewController;
    OpenSpringBoardVC *openSpringBoardVC;
    
    /**
     * OSC Manager
     */
    OSCManager *manager;
    
    /**
     * OSC OutPort
     */
    OSCOutPort *outPort;
    
}

@property (nonatomic, readwrite, strong) IBOutlet UIButton *octopocusButton;
@property (nonatomic, readwrite, strong) IBOutlet UIButton *desktopButton;

- (IBAction)octopocusButtonTapped;
- (IBAction)desktopButtonTapped;

//@property (strong, nonatomic) EvaluationDetailViewController *detailViewController;

@end
