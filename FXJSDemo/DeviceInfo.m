//
//  DeviceInfo.m
//  FXJS
//
//  Created by Saša Branković on 17.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "DeviceInfo.h"
#import "UIWebView+FXJS.h"

@implementation DeviceInfo
- (void) infoWithParameters:(NSArray *)parameters webView:(UIWebView*)webView
{
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    
    UIDevice *device = [UIDevice currentDevice];
    NSLocale *locale = [NSLocale currentLocale];
    
    [deviceInfo setObject:[device model] forKey:@"model"];
    [deviceInfo setObject:[device systemName ] forKey:@"systemName"];
    [deviceInfo setObject:[device systemVersion] forKey:@"systemVersion"];
    [deviceInfo setObject:[locale localeIdentifier] forKey:@"country"];
    
    NSString *callback = [parameters objectAtIndex:0];
   
    [webView evaluateJavaScriptFunction:callback withParameters:deviceInfo, nil];
}
@end
