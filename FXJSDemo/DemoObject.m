//
//  DemoObject.m
//  FXJS
//
//  Created by Saša Branković on 4.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "DemoObject.h"

@implementation DemoObject
- (void)helloWithParameters:(id)parameters callback:(void (^)(id))callback
{
    callback(@"world");
}
@end
