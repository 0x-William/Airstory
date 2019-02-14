//
//  Utils.h
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface Utils : NSObject

+ (BOOL) displaysResponseDialog : (id) responseObject ;
+ (void) displaysErrorDialog : (NSError*)error ;

@end
