//
//  GlobalHeader.m
//  Airstory
//
//  Created by ProDev on 4/21/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "GlobalHeader.h"

float const kRefreshInterval = 60.0f;

NSString* const kShareGroupID = @"group.com.joanna.airstory";
NSString* const kDomain = @"app.airstory.co";
NSString* const kBaseURL = @"https://app.airstory.co/";
NSString* const kCookieSessionName = @"JSESSIONID";
NSString* const kCookieRememberMeName = @"SPRING_SECURITY_REMEMBER_ME_COOKIE";
NSString* const kFirstUse = @"FIRST_USE";
NSString* const kSignoutEndpoint = @"ctrl/logout";
NSString* const kSignupURL = @"https://app.airstory.co/signup?from=iphone";
NSString* const kResetPasswordURL = @"https://app.airstory.co/login/reset-password?from=iphone";
NSString* const kSaveCard = @"mobile/iphone/v1/save-new-card";
NSString* const kUploadEndpoint = @"mobile/iphone/v1/get-upload-url";
NSString* const kServerMultipartDataBoundary = @"MV5xCQfxdlHP0qRm";

NSString* const kConnectionErrorMsg = @"Please check the internet connection";