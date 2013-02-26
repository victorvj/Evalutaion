//
//  RecordViewController.m
//  Draw2
//
//  Created by Hanna Schneider on 11/14/12.
//
//

#import "RecordViewController.h"

#import "Application.h"
#import "Color.h"
#import "Constants.h"
#import "Gesture.h"
#import <QuartzCore/QuartzCore.h>

@interface RecordViewController ()

/**
 * Performs the cancel action
 */
- (void) cancelButton;

/**
 * Performs the save action
 */
- (void) saveButton;

@end

@implementation RecordViewController

#pragma mark -
#pragma mark Properties

@synthesize picker;
@synthesize delegate;
@synthesize adviceLabel;
@synthesize gesturesArray = auxGesturesArray;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver
 */
- (void) dealloc{
    
    colorsArray = nil;
    
    appsArray = nil;
    
    
    availableAppsArray = nil;
    
    availableColorsArray = nil;
    
    delegate = nil;
    
}


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
 * Called after the controller’s view is loaded into memory
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [adviceLabel setBackgroundColor:[UIColor clearColor]];
    [adviceLabel setTextColor:[UIColor darkGrayColor]];
    [adviceLabel setFont:[UIFont systemFontOfSize:14]];
    [adviceLabel setNumberOfLines:2];
    [adviceLabel setTextAlignment:NSTextAlignmentCenter];
    [adviceLabel setText:@"Choose a color and an application\nplease."];

    Color *color1 = [[Color alloc] init];
    [color1 setColorName:@"blue"];
    [color1 setColor:COLOR_BLUE];
    
    Color *color2 = [[Color alloc] init];
    [color2 setColorName:@"lila"];
    [color2 setColor:COLOR_LILA];
    
    Color *color3 = [[Color alloc] init];
    [color3 setColorName:@"red"];
    [color3 setColor:COLOR_RED];
    
    Color *color4 = [[Color alloc] init];
    [color4 setColorName:@"light green"];
    [color4 setColor:COLOR_LIGHTGREEN];
    
    Color *color5 = [[Color alloc] init];
    [color5 setColorName:@"dark green"];
    [color5 setColor:COLOR_DARKGREEN];
    
    Color *color6 = [[Color alloc] init];
    [color6 setColorName:@"orange"];
    [color6 setColor:COLOR_ORANGE];
    
//    Color *color7 = [[[Color alloc] init] autorelease];
//    [color7 setColorName:@"ocre"];
//    [color7 setColor:COLOR_PINK];
    
    Application *app1 = [[Application alloc] init];
    [app1 setAppName:@"Safari"];
    [app1 setSchema:@"http://www.lri.fr/~mbl/ENS/FONDIHM/2012/"];
    [app1 setAppImageName:@"Safari.png"];
    [app1 setIdentifier:1];

    Application *app2 = [[Application alloc] init];
    [app2 setAppName:@"Maps"];
     NSString *title = @"Eiffel Tower";
     float latitude = 48.858278;
     float longitude = 2.294254;
     int zoom = 13;
     NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
    [app2 setSchema:stringURL];
    [app2 setAppImageName:@"Maps.jpg"];
    [app2 setIdentifier:2];

    Application *app3 = [[Application alloc] init];
    [app3 setAppName:@"Phone"];
    [app3 setSchema:@"tel:0695442388"];
    [app3 setAppImageName:@"Phone.jpg"];
    [app3 setIdentifier:3];

//    Application *app4 = [[[Application alloc] init] autorelease];
//    [app4 setAppName:@"SMS"];
//    [app4 setSchema:@"sms:0695442388"];
//    [app4 setAppImageName:@"Phone.jpg"];

    Application *app5 = [[Application alloc] init];
    [app5 setAppName:@"Mail"];
    [app5 setSchema:@"mailto:test@example.com"];
    [app5 setAppImageName:@"Mail.png"];
    [app5 setIdentifier:4];

    Application *app6 = [[Application alloc] init];
    [app6 setAppName:@"iTunes"];
    [app6 setSchema:@"music:"];
    [app6 setAppImageName:@"iTunes.jpg"];
    [app6 setIdentifier:5];

    Application *app7 = [[Application alloc] init];
    [app7 setAppName:@"App Store"];
    [app7 setSchema:@"http://itunes.apple.com/es/app/whatsapp-messenger/id310633997?mt=8"];
    [app7 setAppImageName:@"AppStore.jpg"];
    [app7 setIdentifier:6];

    colorsArray = [[NSMutableArray alloc]initWithObjects: color1, color2, color3, color6, color4, color5, nil];
    appsArray = [[NSMutableArray alloc]initWithObjects:app1, app2, app3, app5, app6, app7, nil];
    
    availableColorsArray = [[NSMutableArray alloc] initWithArray:colorsArray];
    availableAppsArray = [[NSMutableArray alloc] initWithArray:appsArray];
    
    self.navigationItem.title = @"Record Gesture";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)];
        
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [picker reloadAllComponents];

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark PickerView methods

/**
 * Called by the picker view when it needs the number of components.
 * 
 * @param pickerView The picker view requesting the data.
 * @return The number of components (or “columns”) that the picker view should display
 */
- (int) numberOfComponentsInPickerView:(UIPickerView*)picker{
    return 2;
}

/**
 * Called by the picker view when it needs the number of rows for a specified component.
 *
 * @param pickerView The picker view requesting the data.
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 * @return The number of rows for the component.
 */
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return [availableColorsArray count];
    }
    else{
        return [availableAppsArray count];
    }
}

/**
 * Called by the picker view when it needs the title to use for a given row in a given component.
 *
 * @param pickerView An object representing the picker view requesting the data.
 * @param row A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 * @return The string to use as the title of the indicated component row.
 */
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component==0){
        return [[availableColorsArray objectAtIndex:row] colorName];
    }
    else{
        return [[availableAppsArray objectAtIndex:row] appName];
    }
}


/**
 * Called by the picker view when it needs the view to use for a given row in a given component.
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];

    if (component == 0) {
        
        [resultView setBackgroundColor:[[availableColorsArray objectAtIndex:row] color]];
        resultView.layer.cornerRadius = 9.0;
        resultView.layer.masksToBounds = YES;
        resultView.layer.borderColor = [UIColor blackColor].CGColor;
        resultView.layer.borderWidth = 0.0;
        
    } else {
    
        [resultView setBackgroundColor:[UIColor clearColor]];
//        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setText:[[availableAppsArray objectAtIndex:row] appName]];
//        [label setTextColor:[UIColor blackColor]];
//        [resultView addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 35, 35)];
        Application *app = [availableAppsArray objectAtIndex:row];
        UIImage *image = [UIImage imageNamed:[app appImageName]];
        
        [imageView setImage:image];
        imageView.layer.cornerRadius = 9.0;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 0.0;
        [resultView addSubview:imageView];

    }
    
    return resultView;

}


#pragma mark -
#pragma mark User interaction

/*
 * Performs the cancel button action
 */
- (void) cancelButton{
    [delegate recordGestureWithColor:nil
                     applicationName:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Performs the save button action
 */
- (void) saveButton{
    
    Color *color = [availableColorsArray objectAtIndex:[picker selectedRowInComponent:0]];
    Application *app = [availableAppsArray objectAtIndex:[picker selectedRowInComponent:1]];

    [delegate recordGestureWithColor:color
                     applicationName:app];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Gestures array setter 
 */
- (void) setGesturesArray:(NSArray *)gesturesArray {

    if (auxGesturesArray == nil) {
        auxGesturesArray = [[NSMutableArray alloc] init];
    }
    
    [auxGesturesArray removeAllObjects];
    [auxGesturesArray addObjectsFromArray:gesturesArray];
    
    [availableColorsArray removeAllObjects];
    [availableColorsArray addObjectsFromArray:colorsArray];
    
    [availableAppsArray removeAllObjects];
    [availableAppsArray addObjectsFromArray:appsArray];
    
    for (Gesture *gesture in gesturesArray) {
        
        for (Color *color in colorsArray) {
        
            if ([[gesture color] color] == [color color]) {
                
                [availableColorsArray removeObject:color];
                
            }
        
        }
        
        for (Application *app in appsArray) {
            
            if ([[[gesture app] appName] isEqualToString:[app appName]]) {
                
                [availableAppsArray removeObject:app];
                
            }
            
        }
        
    }
        
    [picker reloadAllComponents];
    
}


@end
