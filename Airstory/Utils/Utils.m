//
//  Utils.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "Utils.h"
#import "GlobalHeader.h"
#import "CustomAFNetworking.h"

@implementation Utils

+ (BOOL) displaysResponseDialog : (id) responseObject {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([responseObject[@"success"] boolValue])
        return NO;
    
    NSString *errorStr = [CustomAFNetworking errorMessageFromResponse:responseObject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
    return YES;
}

+ (void) displaysErrorDialog :(NSError*)error {
    NSString *errorStr = [CustomAFNetworking errorMessageFromError:error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
