//
//  JZWebView.h
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//
@import WebKit;
#import <Cocoa/Cocoa.h>

@interface JZWebView : WKWebView

- (void)fixCSS;

- (void)isGitHubLogined:(void (^ _Nullable)( NSNumber * _Nonnull  isOrNot))completionHandler;

@end
