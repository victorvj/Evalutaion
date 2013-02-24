//
//  Color.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 21/11/12.
//
//

#import <Foundation/Foundation.h>

@interface Color : NSObject {

    /**
     * Color name
     */
    NSString *colorName;
    
    /**
     * Color
     */
    UIColor *color;
    
}

@property (nonatomic, readwrite, copy) NSString *colorName;

@property (nonatomic, readwrite, strong) UIColor *color;


@end
