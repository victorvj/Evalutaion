//
//  Tools.m
//  Draw2
//
//  Created by Hanna Schneider on 10/23/12.
//
//

#import "Tools.h"

#import "Constants.h"
#import "Dot.h"

@implementation Tools

#pragma mark -
#pragma dots Tools

/*
 * Returns a the distance between dot1 and dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The distance
 */
+(CGFloat)distanceBetweenPoint:(Dot *)dot1 andPoint:(Dot *)dot2{
    
    CGFloat dx =dot2.x - dot1.x;
    CGFloat dy =dot2.y - dot1.y;
    CGFloat distance = sqrtf((dx*dx)+(dy*dy));
    return distance;
}
    
/*
 * Returns a Dot that has a constant distance from dot1 and it is in the
 * the line from dot1 to dot2
 *
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The dot
 */
+(Dot *)dotInConstantDistanceFromDot:(Dot *)dot1 toDot:(Dot *)dot2 {

    Dot *resultDot = [[Dot alloc] init];
    
    CGFloat dx = dot2.x - dot1.x;
    CGFloat dy = dot2.y - dot1.y;
    
    CGFloat absDx = fabsf(dx);
    CGFloat absDy = fabsf(dy);
    
    // Normalized vector
    CGFloat normVector = sqrtf(absDx*absDx + absDy*absDy);
    
    // Rx = D1x + d * (1/n) * dx
    resultDot.x = dot1.x + SAMPLING_DISTANCE * (1.0f/normVector)*dx;
    resultDot.y = dot1.y + SAMPLING_DISTANCE * (1.0f/normVector)*dy;

    return resultDot;

}


/*
 * Returns a Dot given to other dots used to form a director vector
 *
 * @param dotToTranslate The dot that needs to be traslated
 * @param dot1 The first dot
 * @param dot2 The second dot
 * @return The dot
 */
+(Dot *)transformFromDot:(Dot *)dotToTranslate
               givenDot1:(Dot *)dot1
                    dot2:(Dot *)dot2 {
    
    Dot *resultDot = [[Dot alloc] init];
    
    CGFloat dx = dot2.x - dot1.x;
    CGFloat dy = dot2.y - dot1.y;
    
    CGFloat distance = sqrtf(dx*dx + dy*dy);
    
    CGFloat absDx = fabsf(dx);
    CGFloat absDy = fabsf(dy);
        
        // Normalized vector
    CGFloat normVector = sqrtf(absDx*absDx + absDy*absDy);
    
    if (normVector == 0) {
        resultDot = dotToTranslate;
    } else {
    
        // Rx = D1x + d * (1/n) * dx
        resultDot.x = dotToTranslate.x + distance * (1.0f/normVector)*dx;
        resultDot.y = dotToTranslate.y + distance * (1.0f/normVector)*dy;
    
    }
    
    return resultDot;
    
}



/**
 * Returns true if the whole gesture fits in the ractangle
 *
 * @param gestre The gesture
 * @param rect the area
 * @return true, if fits on screen
 */
+(BOOL)gestureFitsOnScreen:(NSArray *)gesture inRect:(CGRect *) rect{
    
    BOOL outside = NO;
    int count = 0;
    
    while (!outside && count < [gesture count]) {
        Dot* dot = [gesture objectAtIndex:count];
        outside = !((dot.x > rect->origin.x) &&
                    (dot.x < rect->origin.x + rect->size.width) &&
                    ((dot.y > rect->origin.y)&&
                     (dot.y < rect->origin.y + rect->size.height)));
        count++;

    }

    return !outside;
}

@end

