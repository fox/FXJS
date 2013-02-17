//
//  NSObject+NSJSON.m
//  FXJS
//
//  Created by Saša Branković on 17.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "NSObject+NSJSON.h"

@implementation NSObject (NSJSON)
-(NSString *) JSONString
{
    if([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]]) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:0
                                                             error:&error];
        if (jsonData) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            return jsonString;
        }
        
        NSLog(@"Error parsing %@ into JSON. Error: %@", self, error);
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@", self];
}
@end
