//
//  CustomAFNetworking.m
//  Airstory
//
//  Created by ProDev on 4/23/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "CustomAFNetworking.h"
#import "GlobalHeader.h"

@implementation CustomAFNetworking

+ (void) sendRequestWithSharedCookie:(NSString*)method endPoint:(NSString*)endPoint headers:(NSDictionary*)headers parameters:(NSDictionary*)params success:(successCallback)success failure:(failureCallback)failure {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    
    if ([defaults objectForKey:kCookieSessionName] == nil || [defaults objectForKey:kCookieRememberMeName] == nil){
        [defaults setObject:@"" forKey:kCookieSessionName];
        [defaults setObject:@"" forKey:kCookieRememberMeName];
        [defaults synchronize];
    }
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    if ([endPoint isEqualToString:kSaveCard])
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if ([endPoint isEqualToString:kSignoutEndpoint]) {
        [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"airstory-client"];
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:[NSString stringWithFormat:@"%@%@", kBaseURL, endPoint] parameters:params error:nil];
    
    NSHTTPCookie *cookieSession = [NSHTTPCookie cookieWithProperties:@{
                                                                       NSHTTPCookieDomain: kDomain,
                                                                       NSHTTPCookieName: kCookieSessionName,
                                                                       NSHTTPCookieValue: [defaults objectForKey:kCookieSessionName],
                                                                       NSHTTPCookiePath: @"/"
                                                                       }];
    NSHTTPCookie *cookieRemember = [NSHTTPCookie cookieWithProperties:@{
                                                                        NSHTTPCookieDomain: kDomain,
                                                                        NSHTTPCookieName: kCookieRememberMeName,
                                                                        NSHTTPCookieValue: [defaults objectForKey:kCookieRememberMeName],
                                                                        NSHTTPCookiePath: @"/"
                                                                        }];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookieSession, cookieRemember]];
    [request setAllHTTPHeaderFields:cookieHeaders];
    
    for (NSString* key in headers) {
        [request setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [manager.operationQueue addOperation:operation];
}


+ (void) saveCookiesToUserDefaults {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSObject *sessionVal, *rememberVal;
    
    for (NSHTTPCookie *cookie in cookies){
        if ([[cookie name] isEqualToString:kCookieSessionName]) {
            sessionVal = [(NSHTTPCookie *)cookies[0] value];
        }
        else if ([[cookie name] isEqualToString:kCookieRememberMeName])
            rememberVal = [(NSHTTPCookie *)cookies[2] value];
    }
//    NSAssert([[cookies[0] name] isEqualToString:kCookieSessionName] == YES, @"Response Cookie JSESSIONID Wrong!");
//    NSAssert([[cookies[2] name] isEqualToString:kCookieRememberMeName] == YES, @"Response Cookie RememberMe Wrong!");

    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];

    [defaults setObject:sessionVal forKey:kCookieSessionName];
    [defaults setObject:rememberVal forKey:kCookieRememberMeName];
    [defaults synchronize];

}

+ (BOOL) isLoginPage : (AFHTTPRequestOperation*)operation {
    NSDictionary *dic = [operation.response allHeaderFields];
    if ([dic valueForKey:@"login-page"])
        return YES;
    else
        return NO;
}



+ (void) saveSelectedProjectIDToUserDefaults : (NSNumber*)pId {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    
    [defaults setObject:pId forKey:@"ProjectID"];
    [defaults synchronize];
    
}

+ (void) saveTimestampToUserDefaults {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];

    [defaults setObject:[NSDate date] forKey:@"Timestamp"];
    [defaults synchronize];
    
}

+ (NSInteger) availableProjectIndexFromList : (NSArray*)projects {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    NSNumber *pId = [defaults objectForKey:@"ProjectID"];
    
    if (pId == nil || projects == nil) {
        return 0;
    }
    
    for (int i = 0; i < projects.count; i++) {
        if ([pId integerValue] == [projects[i][@"id"] integerValue]) {
            return i;
        }
    }
    
    return 0;
}

+ (NSString*) errorMessageFromResponse:(id) responseObject {
    if (responseObject[@"message"] == nil) {
        return @"An unexpected error occurred. Please try again.\nIf the error persists, contact help@airstory.co";
    }
    else
        return responseObject[@"message"];
}

+ (NSString*) errorMessageFromError:(NSError*) error {
    if (error) {
        if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"The request timed out."]){
            return @"Your request took too long to complete.\nPlease try again in a few moments";
        }
        else if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Request failed: unauthorized (401)"])
            return @"Invalid Username/Password";
        else if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"Request failed: internal server error (500)"])
            return @"An unexpected error occurred. Please try again.\nIf the error persists, contact help@airstory.co";
        else
            return @"Please check the internet connection";
    }
    else
        return @"An unexpected error occurred. Please try again.\nIf the error persists, contact help@airstory.co";
}
    
@end
