//
//  CustomAFNetworking.h
//  Airstory
//
//  Created by ProDev on 4/23/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GlobalHeader.h"

typedef void (^successCallback)(AFHTTPRequestOperation *operation, id responseObject) ;
typedef void (^failureCallback)(AFHTTPRequestOperation *operation, NSError *error) ;

@interface CustomAFNetworking : AFHTTPSessionManager


+ (void) sendRequestWithSharedCookie:(NSString*)method endPoint:(NSString*)endPoint headers:(NSDictionary*)headers parameters:(NSDictionary*)params success:(successCallback)success failure:(failureCallback)failure ;
+ (void) saveCookiesToUserDefaults;
+ (BOOL) isLoginPage : (AFHTTPRequestOperation*)operation;


+ (void) saveSelectedProjectIDToUserDefaults : (NSString*)pId ;
+ (void) saveTimestampToUserDefaults ;
+ (NSInteger) availableProjectIndexFromList : (NSArray*)projects ;

+ (NSString*) errorMessageFromResponse:(id) responseObject ;
+ (NSString*) errorMessageFromError:(NSError*) error ;

@end