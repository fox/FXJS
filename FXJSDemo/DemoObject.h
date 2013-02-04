//
//  DemoObject.h
//  FXJS
//
//  Created by Saša Branković on 4.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoObject : NSObject
-(void)helloWithParameters:(id)parameters callback:(void(^)(id))callback;
@end
