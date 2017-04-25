//
//  JZMainViewController.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "JZMainViewController.h"
#import <WebKit/WebKit.h>
#import "JZWebView.h"

@interface JZMainViewController ()<WKNavigationDelegate,NSSplitViewDelegate,WKUIDelegate,WebPolicyDelegate>
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
    self.webView = [[JZWebView alloc] initWithFrame:CGRectMake(0, 0, self.visualEffectView.frame.size.width, self.visualEffectView.frame.size.height)];
    [self.webView setValue:@YES forKey:@"drawsTransparentBackground"];
    [self.visualEffectView addSubview:self.webView];
    self.webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self loadDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_SWITCH_BOARD:) name:@"JZ_SWITCH_BOARD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_RELOAD_BOARD:) name:@"JZ_RELOAD_BOARD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_REVERT_BOARD:) name:@"JZ_REVERT_BOARD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_SHOW_BOARD_MENU:) name:@"JZ_SHOW_BOARD_MENU" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_ADD_CARDS_FROM:) name:@"JZ_ADD_CARDS_FROM" object:nil];
}


- (void)loadDefault
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"JZ_LAUNCH_URL"];
    if (url)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/JustinFincher/BoardForGitHub/projects/1?fullscreen=true"]]];
    }
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [self refreshWebView:webView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self refreshWebView:webView];
}
- (void)refreshWebView:(WKWebView *)webView
{
    if (webView == self.webView)
    {
        [self.webView fixCSS];
        
        [self.webView isGitHubLogined:^(NSNumber * loginedInOrNot)
         {
             if (![loginedInOrNot boolValue])
             {
                 bool isInProcess = ([self.webView.URL.absoluteString isEqualToString:@"https://github.com/login"] || [self.webView.URL.absoluteString isEqualToString:@"https://github.com/session"] || [self.webView.URL.absoluteString isEqualToString:@"https://github.com/sessions/two-factor"]);
                 if (!isInProcess)
                 {
                     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/login"]]];
                 }
             }
         }];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSLog(@"URL String %@",urlString);
    NSError *error;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"https://github.com/([-\\w\\.]+)/([-\\w\\.]+)/projects/([-\\w\\.]+)" options:0 error:&error];
    
    NSArray *arrayOfAllMatches = [reg matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    if (arrayOfAllMatches.count > 0)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:@"JZ_LAUNCH_URL"];
        if (![urlString containsString:@"?fullscreen=true"])
        {
            decisionHandler (WKNavigationActionPolicyCancel);
            NSString *newString = [urlString stringByAppendingString:@"?fullscreen=true"];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newString]]];
        }else
        {
            decisionHandler (WKNavigationActionPolicyAllow);
        }
    }else if ([urlString isEqualToString:@"https://github.com/login"] || [urlString isEqualToString:@"https://github.com/session"] || [urlString isEqualToString:@"https://github.com/sessions/two-factor"])
    {
        decisionHandler (WKNavigationActionPolicyAllow);
    }else if ([urlString isEqualToString:@"https://github.com/"])
    {
        decisionHandler (WKNavigationActionPolicyAllow);
        [self loadDefault];
    }
    else
    {
        decisionHandler (WKNavigationActionPolicyCancel);
        [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
    }
}

#pragma UI Delegate
- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert runModal];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setMessageText:message];
    completionHandler([alert runModal] == NSAlertFirstButtonReturn);
}
#pragma mark - Notification Center
- (void)JZ_SHOW_BOARD_MENU:(NSNotification *)notif
{
    [self.webView toggleBoardMenu];
}
- (void)JZ_ADD_CARDS_FROM:(NSNotification *)notif
{
    [self.webView toggleAddCardsFrom];
}
- (void)JZ_REVERT_BOARD:(NSNotification *)notif
{
    [self.webView goBack];
}
- (void)JZ_RELOAD_BOARD:(NSNotification *)notif
{
    [self.webView reload];
}
- (void)JZ_SWITCH_BOARD:(NSNotification *)notif
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setInformativeText:@"Must be a project url, eg: https://github.com/Wow/SuchRepo/projects/1, or This app will open url in an external web broswer"];
    [alert setMessageText:@"Project URL Please 🐱"];
    [alert addButtonWithTitle:@"Go"];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 280, 24)];
    [input setStringValue:@""];
    [alert setAccessoryView:input];
    [[alert window] setInitialFirstResponder: input];
    NSInteger button = [alert runModal];
    
    if (button == NSAlertFirstButtonReturn)
    {
        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL URLWithString:[input stringValue]]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[input stringValue]]]];
    } else if (button == NSAlertSecondButtonReturn)
    {
        
    }
}

- (void)setAsCurrentBoard:(NSPasteboard *)pboard
                 userData:(NSString *)userData error:(NSString **)error
{
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    BOOL canRead = [pboard canReadObjectForClasses:classes options:options];
    if (!canRead)
    {
        *error = NSLocalizedString(@"Error: couldn't set board.",
                                   @"no url found");
        return;
    }
    
    NSString *pboardString = [pboard stringForType:NSPasteboardTypeString];
    NSURL *url = [NSURL URLWithString:pboardString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
