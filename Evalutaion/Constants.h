//
//  Constants.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 23/10/12.
//
//


#pragma mark -
#pragma mark Distances

//#define IPHONE                                                          YES

/**
 * Defines the distance between two points in a gesture
 */
#define SAMPLING_DISTANCE                                               5.0f

/**
 * Defines the error distance allowed
 */
#define ERROR_DISTANCE                                                  SAMPLING_DISTANCE + 15.0f

#pragma mark -
#pragma mark Gesture thickness

/**
 * Gesture thickness
 */
#define GESTURE_THICKNESS                                               16.0f

#pragma mark -
#pragma mark Expert time

/**
 * Expert time
 */
#define EXPERT_TIME                                                     0.015f

#pragma mark -
#pragma mark Colors definition

/**
 * Defines the color blue
 */
#define COLOR_BLUE          [UIColor colorWithRed:8.0/255.0 green:80.0/255.0 blue:150.0/255.0 alpha:1.0]

/**
 * Defines the color lila
 */
#define COLOR_LILA          [UIColor colorWithRed:147.0/255.0 green:139.0/255.0 blue:186.0/255.0 alpha:1.0]

/**
 * Defines the color red
 */
#define COLOR_RED           [UIColor colorWithRed:231.0/255.0 green:99.0/255.0 blue:94.0/255.0 alpha:1.0]

/**
 * Defines the color gray
 */
#define COLOR_GRAY          [UIColor colorWithRed:214.0/255.0 green:209.0/255.0 blue:205.0/255.0 alpha:1.0]

/**
 * Defines the color light green
 */
#define COLOR_LIGHTGREEN    [UIColor colorWithRed:137.0/255.0 green:224.0/255.0 blue:173.0/255.0 alpha:1.0]

/**
 * Defines the color dark green
 */
#define COLOR_DARKGREEN     [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:140.0/255.0 alpha:1.0]

/**
 * Defines the color orange
 */
#define COLOR_ORANGE        [UIColor colorWithRed:223.0/255.0 green:160.0/255.0 blue:93.0/255.0 alpha:1.0]

/**
 * Defines the color pink
 */
#define COLOR_PINK          [UIColor colorWithRed:196.0/255.0 green:133.0/255.0 blue:176.0/255.0 alpha:1.0]

#pragma mark -
#pragma mark Modes

#define DEBUGGING_MODE                                                    YES

//@property (nonatomic) BOOL debugging_mode;