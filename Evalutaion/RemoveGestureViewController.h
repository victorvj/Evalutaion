//
//  RemoveGestureViewController.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 27/11/12.
//
//

#import <UIKit/UIKit.h>

@protocol RemoveGestureViewControllerDelegate

/**
 * Gestures remove result transmits the array of gestures that will stay
 *
 * @param array The array of gestures
 */
- (void)gesturesRemovedResult:(NSArray *)array;

@end

@interface RemoveGestureViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    /**
     * Table view
     */
    UITableView *table;
    
    /**
     * Gestures array
     */
    NSMutableArray *auxGesturesArray;

    /**
     * Delegate
     */
    id<RemoveGestureViewControllerDelegate>__weak delegate;
    
}


/**
 * Table view
 */
@property(nonatomic, readwrite, strong) IBOutlet UITableView *table;

/**
 * Gestures array
 */
@property(nonatomic, readwrite, strong) NSArray *gesturesArray;

/**
 * Delegate
 */
@property (nonatomic, readwrite, weak) id<RemoveGestureViewControllerDelegate>delegate;

@end
