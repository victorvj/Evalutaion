//
//  Tools.h
//  Draw2
//
//  Created by Hanna Schneider on 10/23/12.
//
//

#import <Foundation/Foundation.h>
#import "Dot.h"

@interface Tools : NSObject

/**
 * Returns a the distance between dot1 and dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The distance 
 */
+(CGFloat)distanceBetweenPoint:(Dot *)dot1 andPoint:(Dot *)dot2;

/**
 * Returns a Dot that has a constant distance from dot1 and it is in the
 * the line from dot1 to dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The dot 
 */
+(Dot *)dotInConstantDistanceFromDot:(Dot *)dot1 toDot:(Dot *)dot2;

/**
 * Returns a Dot given to other dots used to form a director vector
 *
 * @param dotToTranslate The dot that needs to be traslated
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The dot
 */
+(Dot *)transformFromDot:(Dot *)dotToTranslate
               givenDot1:(Dot *)dot1
                    dot2:(Dot *)dot2;


/**
 * Returns true if the whole gesture fits in the ractangle
 *
 * @param gestre The gesture 
 * @param rect the area
 * @return true, if fits on screen
 */
+(BOOL)gestureFitsOnScreen:(NSArray *)gesture inRect:(CGRect *) rect;


@end
