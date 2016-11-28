//
//  JZMainViewController.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "JZMainViewController.h"
#import "JZWebView.h"

@interface JZMainViewController ()<WKNavigationDelegate>
@property (weak) IBOutlet NSVisualEffectView *visualEffectView;
@property (strong,nonatomic) JZWebView *webView;

@end

@implementation JZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    [self.webView setWantsLayer:YES];
    [self.webView.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    
    
    self.webView = [[JZWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webView setValue:@YES forKey:@"drawsTransparentBackground"];
    [self.visualEffectView addSubview:self.webView];
    self.webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.webView.navigationDelegate = self;
//    [self.webView loadHTMLString:@"<html><head></head><body style='margin:0px;padding:0px;background-color: rgba(0, 0, 0, 0);color: rgba(0, 0, 0, 0);'></body></html>" baseURL:[NSURL URLWithString:@""]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/CSU-Apple-Lab/Slides-for-iOS-Class/projects/1?fullscreen=true"]]];
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    if (webView == self.webView)
    {
        [self.webView fixCSS];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (webView == self.webView)
    {
        [self.webView fixCSS];
    }
}

@end
