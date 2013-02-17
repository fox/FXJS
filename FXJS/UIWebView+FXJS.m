//
//  UIWebView+FXJS.m
//  FXJS
//
//  Created by Saša Branković on 16.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "UIWebView+FXJS.h"
#import "NSObject+NSJSON.h"

@implementation UIWebView (FXJS)

- (NSString *)evaluateJavaScript:(NSString *)javaScript, ...
{
    va_list args;
    va_start(args, javaScript);
    NSString *code = [[NSString alloc] initWithFormat:javaScript arguments:args];
    NSLog(@"Evaluating javaScript: %@", code);
    NSString *result = [self stringByEvaluatingJavaScriptFromString:code];
    va_end(args);
    return result;
}

-(void) evaluateJavaScriptFunction:(NSString *)function withParameters:(id)parameter, ...
{
    NSMutableArray *parameters = [NSMutableArray array];
    va_list args;
    va_start(args, parameter);
    id obj = parameter;
    do {
        [parameters addObject:obj];
    } while ((obj = va_arg(args, id)));
    va_end(args);
    
    [self evaluateJavaScript:@"%@.apply(undefined, %@)", function, [parameters JSONString]];
}
@end
