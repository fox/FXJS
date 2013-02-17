//
//  ViewController.m
//  FXJSDemo
//
//  Created by Saša Branković on 4.2.2013..
//  Copyright (c) 2013. Saša Branković. All rights reserved.
//

#import "ViewController.h"
#import "FXJSDelegate.h"
#import "Calculator.h"
#import "DeviceInfo.h"

@interface ViewController ()
@property (nonatomic, strong) FXJSDelegate *JSDelegate;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.JSDelegate = [[FXJSDelegate alloc] init];
    
    id calculator = [[Calculator alloc] init];
    id device = [[DeviceInfo alloc] init];
    
    [self.JSDelegate addJavaScriptObject:calculator name:@"calculator"];
    [self.JSDelegate addJavaScriptObject:device name:@"device"];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"calculator" ofType:@"html" inDirectory:@"www"]];
    
    self.webView.delegate = self.JSDelegate;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

@end
