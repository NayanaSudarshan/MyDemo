//
//  DataUtility.m
//  Demo
//
//  Created by Satish on 11/01/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "DataUtility.h"
#import "CanadaDetails.h"

@implementation DataUtility

+(void)fetchJSONDataWithCallback:(void (^)(NSDictionary * JSONdata))callback {
    NSURL * url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
        if (!error) {
            NSError * error;
            NSString * encodedString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
            NSData * resultData = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * JSONdata = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:&error];
            [encodedString release];
            callback(JSONdata);
        }
        else {
            NSLog(@"Failed with an error: %@", error.localizedDescription);
        }
    }];
}

+(void)fetchCanadaDetailsWithCallback:(void (^)(NSArray * results, NSString * title))callback {
    [self fetchJSONDataWithCallback:^(NSDictionary * JSONData) {
        NSMutableArray * results = [[[NSMutableArray alloc] init] autorelease];
        
        for (NSDictionary * item in [JSONData objectForKey:@"rows"]) {
            CanadaDetails * details = [[[CanadaDetails alloc] init] autorelease];
            details.title = [item objectForKey:@"title"];
            details.topicDescription = [item objectForKey:@"description"];
            details.imageURL = [item objectForKey:@"imageHref"];
            [results addObject:details];
        }
        
        if (callback) {
            callback (results, [JSONData objectForKey:@"title"]);
        }
    }];
}

+(void)downloadImageForURL:(NSString *)url WithCallback:(void (^)(BOOL succeeded, NSData * data))callback {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (!error) {
            callback(YES, data);
        }
        else {
            callback(NO, nil);
        }
    }];
}

@end
