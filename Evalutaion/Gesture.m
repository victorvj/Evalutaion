//
//  Gesture.m
//  Draw2
//
//  Created by Victor Valle Juarranz on 01/11/12.
//
//

#import "Gesture.h"

@implementation Gesture

#pragma mark -
#pragma mark Properties

@synthesize app;
@synthesize color;
@synthesize gesture = auxGesture;
@synthesize thickness;

#pragma mark Getters and Setters

/**
 * Sets the gesture
 */
- (void)setGesture:(NSArray *)gesture {
    
    if (auxGesture == nil) {
        
        auxGesture = [[NSMutableArray alloc] init];
        
    }
    
    [auxGesture removeAllObjects];
    
    [auxGesture addObjectsFromArray:gesture];
    

}


/**
 * Returns the gesture
 *
 * @return The gesture
 */
- (NSArray *)gesture {

    return [NSArray arrayWithArray:auxGesture];

}

@end
