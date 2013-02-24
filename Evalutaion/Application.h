//
//  Application.h
//  Draw2
//
//  Created by Victor Valle Juarranz on 21/11/12.
//
//

#import <Foundation/Foundation.h>

@interface Application : NSObject {
    
    /**
     * App name
     */
    NSString *appName;
    
    /**
     * Schema
     */
    NSString *schema;
    
    /**
     * Application image name
     */
    NSString *appImageName;
    
}

@property (nonatomic, readwrite, copy) NSString *appName;

@property (nonatomic, readwrite, copy) NSString *schema;

@property (nonatomic, readwrite, copy) NSString *appImageName;

@end
