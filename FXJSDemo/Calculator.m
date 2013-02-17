//
//  Calculator.m
//  FXJS
//
//  Created by Saša Branković on 4.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "Calculator.h"
#import "UIWebView+FXJS.h"

@implementation Calculator
- (void)sumWithParameters:(NSArray*)parameters webView:(UIWebView *)webView
{
    NSInteger a = [[parameters objectAtIndex:0] integerValue];
    NSInteger b = [[parameters objectAtIndex:1] integerValue];
    NSString *callback = [parameters objectAtIndex:2];
    NSNumber *sum = [NSNumber numberWithInt:a+b];
    
    [webView evaluateJavaScriptFunction:callback withParameters:sum, nil];
}
@end
