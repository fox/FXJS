//
//  FXJSDelegate.m
//  FXJS
//
//  Created by Saša Branković on 20.1.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "FXJSDelegate.h"
#import <objc/runtime.h>

@interface FXJSDelegate()
@property (nonatomic, strong) NSMutableDictionary *objects;
@property (nonatomic, strong) id<UIWebViewDelegate> innerDelegate;
@end

@implementation FXJSDelegate
- (id)initWithWebViewDelegate:(id<UIWebViewDelegate>)delegate {
    if (self = [super init]) {
        self.innerDelegate = delegate;
        self.objects = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark UIWebViewDelegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.innerDelegate webView:webView didFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    NSString *scheme = URL.scheme;
    
    if ([scheme isEqualToString:@"fxjs"]) {
        [self processWebView:webView URL:URL];
        return NO;
    }
    
    return [self.innerDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.innerDelegate webViewDidFinishLoad:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.innerDelegate webViewDidStartLoad:webView];
}

- (NSString *)JSCodeFromObject:(id)object name:(NSString *)name
{
    NSMutableString JSCode = [NSMutableString stringWithString:@""];
    [JSCode appendFormat:@"%@ = {};", name];
    
    int i = 0;
    unsigned int mc = 0;
    Method *mlist = class_copyMethodList(object_getClass(t), &mc);
    for(i = 0; i < mc; i++) {
        NSString *function = [[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]
                              stringByReplacingOccurrencesOfString:@"WithParameters:" withString:@""];
        [JSCode appendFormat:@"%@.%@ = function() {\
            var args = [];\
            for (var i = 0, l = arguments.length; i < l; i++) { args.push(arguments[i]); }\
            var url = 'fxjs//%@/%@/' + escape(JSON.stringify(args));\
            window.location = url;", name, function];
    }
                                             
    return JSCode;
}

- (void)addJavascriptInterfaceToWebView:(UIWebView *)webView withObject:(id)object name:(NSString *)name
{
    [self.objects setObject:object forKey:name];
    NSString *JSCode = [self JSCodeFromObject:object name:name];
    [webView stringByEvaluatingJavaScriptFromString:JSCode];
}

- (void)createCallback {
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    JSCode JSCode = [NSString stringWithFormat:@"%@(%@);", self.callback, JSONString];
    [self.webView stringByEvaluatingJavaScriptFromString:JSCode];

}

- (void)processWebView:(UIWebView *)webView URL:(NSURL *)URL {
    NSString *URLComponents = [[URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
