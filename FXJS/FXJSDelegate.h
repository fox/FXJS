//
//  FXJSDelegate.h
//  FXJS
//
//  Created by Saša Branković on 20.1.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.

@interface FXJSDelegate : NSObject<UIWebViewDelegate>
- (void)addJavaScriptObject:(id)object name:(NSString *)name;
@end

