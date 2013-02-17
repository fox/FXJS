//
//  NSString+NSJSON.m
//  FXJS
//
//  Created by Saša Branković on 17.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "NSString+NSJSON.h"

@implementation NSString (NSJSON)
-(id)JSONObject
{
    NSError *error;
    id obj = [NSJSONSerialization
              JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
              options:0
              error:&error];

    if (!obj) {
        NSLog(@"Error parsing %@ as JSON: %@", self, error);
    }
    
    return obj;
}
@end
