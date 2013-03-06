//
//  FXJSDelegate.m
//  FXJS
//
//  Created by Saša Branković on 20.1.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "NSString+NSJSON.h"
#import "FXJSDelegate.h"
#import <objc/runtime.h>

@interface FXJSDelegate()
@property (nonatomic, strong) NSMutableDictionary *javaScriptObjects;
@end

@implementation FXJSDelegate

- (id)init
{
    if (self = [super init]) {
        self.javaScriptObjects = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addJavaScriptObject:(id)object name:(NSString *)name
{
    [self.javaScriptObjects setObject:object forKey:name];
}

#pragma mark UIWebViewDelegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
    
    if ([URL.scheme isEqualToString:@"fxjs"]) {
        [self processWebView:webView URL:URL];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadJavascriptObjectsIntoWebView:webView];
    [webView stringByEvaluatingJavaScriptFromString:@"if (window.onscreenready) { window.onscreenready(); }" ];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)loadJavaScriptObject:(id)object name:(NSString *)name intoWebView:(UIWebView *)webView
{
    NSMutableString *javaScript = [NSMutableString stringWithString:@""];
    
    BOOL undefined = [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.%@ === undefined;", name]] boolValue];
    if (undefined == NO) {
        return;
    }
    
    [javaScript appendFormat:@"%@ = {};", name];
    
    int i = 0;
    unsigned int mc = 0;
    Method *mlist = class_copyMethodList(object_getClass(object), &mc);
    for (i = 0; i < mc; i++) {
    
        NSString* methodName = [NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))];
        if ([methodName rangeOfString:@"WithParameters:webView:"].location == NSNotFound) {
            continue;
        }
        
        NSString *function = [methodName stringByReplacingOccurrencesOfString:@"WithParameters:webView:" withString:@""];
        
        [javaScript appendFormat:@"%@.%@ = function() {\
            var args = [];\
            for (var i = 0, l = arguments.length; i < l; i++) {\
                if (typeof(arguments[i]) === 'function') {\
                    var callback = '_c' + Math.floor((Math.random()*1000000000)+1);\
                    window[callback] = arguments[i];\
                    args.push(callback);\
                } else {\
                    args.push(arguments[i]);\
                }\
            }\
            var payload = { name: '%@', function: '%@', args: args };\
            var url = 'fxjs://'+ escape(JSON.stringify(payload));\
            window.location.href = url; };", name, function, name, function];
    }
    
    NSLog(@"%@", javaScript);
    [webView stringByEvaluatingJavaScriptFromString:javaScript];
    
}

- (void)loadJavascriptObjectsIntoWebView:(UIWebView *)webView
{
    for (id name in self.javaScriptObjects) {
        id object = [self.javaScriptObjects objectForKey:name];
        [self loadJavaScriptObject:object name:name intoWebView:(UIWebView *)webView];
    }
}

- (void)processWebView:(UIWebView *)webView URL:(NSURL *)URL;
{
    id payloadJSON = [URL.host JSONObject];
    if (!payloadJSON) {
        return;
    }
    
    NSString *name = [payloadJSON objectForKey:@"name"];
    NSString *function = [payloadJSON objectForKey:@"function"];
    NSArray *args = [payloadJSON objectForKey:@"args"];

    id obj = [self.javaScriptObjects objectForKey:name];
    if (!obj) {
        NSLog(@"No JavaScript object %@", name);
    }
    
    NSString *selectorName = [NSString stringWithFormat:@"%@WithParameters:webView:", function];
    SEL selector = NSSelectorFromString(selectorName);
    
    if ([obj respondsToSelector:selector]) {
        [obj performSelector:selector withObject:args withObject:webView];
    } else {
        NSLog(@"Cannot execute %@ - %@ does not respond to %@", function, name, selectorName);
    }
}

@end
