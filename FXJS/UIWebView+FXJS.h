//
//  UIWebView+FXJS.h
//  FXJS
//
//  Created by Saša Branković on 16.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (FXJS)
- (NSString *)evaluateJavaScript:(NSString *)javaScript, ...;
- (void) evaluateJavaScriptFunction:(NSString *)function withParameters:(id)parameter, ... NS_REQUIRES_NIL_TERMINATION;
@end
