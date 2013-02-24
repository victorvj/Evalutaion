//
//  RemoveGestureViewController.m
//  Draw2
//
//  Created by Victor Valle Juarranz on 27/11/12.
//
//

#import "RemoveGestureViewController.h"

#import "Application.h"
#import "Color.h"
#import "Constants.h"
#import "Gesture.h"

#import <QuartzCore/QuartzCore.h>

@interface RemoveGestureViewController ()

/**
 * Performs the cancel action
 */
- (void) cancelButton;

/**
 * Performs the save action
 */
- (void) saveButton;

@end

@implementation RemoveGestureViewController

#pragma mark -
#pragma mark Properties

@synthesize table = table;
@synthesize gesturesArray = auxGesturesArray;
@synthesize delegate = delegate;

#pragma mark -
#pragma mark Memory management

/**
 * Deallocates the memory occupied by the receiver.
 */
- (void)dealloc {

    
    auxGesturesArray = nil;
    
    delegate = nil;

}

#pragma mark -
#pragma mark View lifecycle

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Your Gestures";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButton)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton)];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark -
#pragma mark Table methods

/**
 * Tells the data source to return the number of rows in a given section of a table view. (required)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger result = [auxGesturesArray count];
    return result;

}

/**
 * Asks the data source for a cell to insert in a particular location of the table view. (required)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (result == nil)  {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [result setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 35, 35)];
    
    Gesture *gesture = [auxGesturesArray objectAtIndex:[indexPath row]];
    Application *app = [gesture app];
    UIImage *image = [UIImage imageNamed:[app appImageName]];
    
    [imageView setImage:image];
    imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor blackColor].CGColor;
    imageView.layer.borderWidth = 0.0;
    
    [result addSubview:imageView];
    
    UIView *view = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 150, 35)];
    
    view.layer.cornerRadius = 9.0;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0;
    [view setBackgroundColor:[[gesture color] color]];
    
    [result addSubview:view];
    
    return result;

}


/**
 * Asks the data source to verify that the given row is editable.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

/**
 * Asks the data source to commit the insertion or deletion of a specified row in the receiver.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [auxGesturesArray removeObjectAtIndex:[indexPath row]];
        [tableView reloadData];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30.0f;
    
}
// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.0f)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30.0f)];
    
    [view setBackgroundColor:[UIColor clearColor]];
    
    [label setBackgroundColor:COLOR_GRAY];
    [label setText:@"Swipe left to remove"];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];

    [view addSubview:label];
    
    return view;

}

#pragma mark -

-(void)setGesturesArray:(NSArray *)gesturesArray {

    if (auxGesturesArray == nil) {
        
        auxGesturesArray = [[NSMutableArray alloc] init];
        
    }
    
    [auxGesturesArray removeAllObjects];
    [auxGesturesArray addObjectsFromArray:gesturesArray];
    
    [table reloadData];

}


#pragma mark -
#pragma mark User interaction

/*
 * Performs the cancel button action
 */
- (void) cancelButton{
    
    [delegate gesturesRemovedResult:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Performs the save button action
 */
- (void) saveButton{
    
    [delegate gesturesRemovedResult:auxGesturesArray];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
