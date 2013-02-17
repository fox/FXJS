# FXJS

FXJS makes it easy to communicate between JavaScript and Objective-C in a UIWebView. It works by injecting the Objective-C object into JavasScript, allowing the object's methods to be accessed from JavaScript. 

Basically, this is variation of a similar feature found in Android SDK (WebView.addJavaScriptInterface).
 
## Usage

First, copy the FXJS folder into your project.

Then write your Objective-C class

```objc
@interface Calculator : NSObject
- (void)sumWithParameters:(NSArray*)parameters webView:(UIWebView *)webView;
@end
``` 
create the JSDelegate, add object to it, set webView delegate

```objc
self.JSDelegate = [[FXJSDelegate alloc] init];
[self.JSDelegate addJavaScriptObject:calculator name:@"calculator"];
self.webView.delegate = self.JSDelegate;    
```

and you can now make calls to calculator object from your JavaScript

```javascript
calculator.sum(2,3, function(result) { 
	alert(result) 
}); // will invoke the Calculator sumWithParameters
```