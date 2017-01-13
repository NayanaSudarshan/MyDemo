//
//  DataUtility.h
//  Demo
//
//  Created by Satish on 11/01/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtility : NSObject
/*
 @abstract Fetches the details about Canada using asynchronous request and returs the result using call back.
 @param
    callback: Returns the result data and and the title string
 */
+(void)fetchCanadaDetailsWithCallback:(void (^)(NSArray * results, NSString * title))callback;

/*
 @abstract Fetches the images using asynchronous request and returs the result using call back.
 @param
    callback: Returns the status of the reuest and image data
 */
+(void)downloadImageForURL:(NSString *)url WithCallback:(void (^)(BOOL succeeded, NSData * data))callback;

@end
