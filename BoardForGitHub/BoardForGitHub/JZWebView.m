//
//  JZWebView.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "JZWebView.h"
#import "JZReachability.h"

@interface JZWebView ()<WKScriptMessageHandler>

@property (strong) WKUserScript *jsInterfaceUserScript;
@property (strong,nonatomic) JZReachability *reachability;


@end

@implementation JZWebView

- (id)init
{
    if ([super init])
    {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if ([super initWithCoder:coder])
    {
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    conf.userContentController = [[WKUserContentController alloc] init];
    [conf.userContentController addScriptMessageHandler:self name:@"switchBoard"];
    
    if ([super initWithFrame:frameRect configuration:conf])
    {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [[NSColor clearColor] CGColor];
        [self refreshJS];
        [self fixCSS];
        
#if DEBUG
        [self.configuration .preferences setValue:@YES forKey:@"developerExtrasEnabled"];
#endif
        
        __weak JZWebView *weakSelf = self;
        self.reachability = [JZReachability reachabilityWithHostname:@"www.github.com"];
        self.reachability.reachableBlock = ^(JZReachability *reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [weakSelf reload];
                           });
        };
        
        self.reachability.unreachableBlock = ^(JZReachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               NSAlert *alert = [[NSAlert alloc] init];
                               [alert addButtonWithTitle:@"Reload"];
                               [alert addButtonWithTitle:@"Close Board"];
                               [alert setMessageText:@"No Internet Connection"];
                               [alert setInformativeText:@"Without Internet Connection, Board For GitHub won't work."];
                               [alert setAlertStyle:NSWarningAlertStyle];
                               
                               [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
                               NSModalResponse response = [alert runModal];
                               if (response == NSAlertFirstButtonReturn)
                               {
                                   [weakSelf reload];
                               }else
                               {
                                   [NSApp terminate:weakSelf];
                               }
                           });
            
        };
        [self.reachability startNotifier];
    }
    return self;
    
}

- (void)refreshJS
{
    NSString *jqueryCode = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"jquery-3.1.1.min" ofType: @"js"] encoding:NSUTF8StringEncoding error:NULL];
    
    self.jsInterfaceUserScript = [[WKUserScript alloc] initWithSource:jqueryCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    
    [self.configuration.userContentController removeAllUserScripts];
    [self.configuration.userContentController addUserScript:self.jsInterfaceUserScript];
}

- (void)fixCSS
{
    // body remove min-width
    [self evaluateJavaScript:@"$(document.body).css('min-width', '600px');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // dont display breadcrumb
    [self evaluateJavaScript:@"$('.project-breadcrumb.text-normal.v-align-bottom').remove();" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // columns move down 50px
    [self evaluateJavaScript:@"$('.project-columns').css('background-color', 'rgba(0, 0, 0, 0)').css('margin-top', '50px');" completionHandler:^(id whatIsThis,NSError *err){}];
    // menus move down 50px
    [self evaluateJavaScript:@"$('.project-pane').css('margin-top', '50px');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    [self evaluateJavaScript:@"$(document.body).css('background-color', 'transparent');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // octocat logo move right (windows buttons here)
    [self evaluateJavaScript:@"$('.header-logo-invertocat').css('margin-left', '50px');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // also give logo a onclick event
    [self evaluateJavaScript:@"$('.header-logo-invertocat').removeAttr('href').unbind('click').click(function(){ window.webkit.messageHandlers.switchBoard.postMessage('switch'); });" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // remove "quit full screen" button
    [self evaluateJavaScript:@"$('.d-table.mt-1.float-right > .d-table-cell.pr-4:eq(2)').remove();" completionHandler:^(id whatIsThis,NSError *err){}];
    // remove "settings" button
    [self evaluateJavaScript:@"$('.d-table.mt-1.float-right > .d-table-cell:eq(2)').remove();" completionHandler:^(id whatIsThis,NSError *err){}];
    //move right a little bit
    [self evaluateJavaScript:@"$('.d-table.mt-1.float-right > .d-table-cell:eq(1)').css('padding-right', '0px !important');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // ehhh header get fixed because it's now a titlebar
    [self evaluateJavaScript:@"$('.project-header.border-bottom.clearfix').css('position', 'fixed').css('z-index', '99999').css('width', '100%');" completionHandler:^(id whatIsThis,NSError *err){}];
    
    // make titlebar blur, but buggy. comment out.
    //    [self evaluateJavaScript:@"$('.project-header.border-bottom.clearfix').css('backdrop-filter', 'blur(10px)').css('background-color', 'rgba(0, 0, 0, 0.5)');" completionHandler:^(id whatIsThis,NSError *err){}];
    
}

- (void)isGitHubLogined:(void (^ _Nullable)( NSNumber * _Nonnull  isOrNot))completionHandler;
{
    [self evaluateJavaScript:@"$(document.body).hasClass( 'logged-in' );" completionHandler:^(id whatIsThis,NSError *err)
     {
         if ([self.URL.absoluteString isEqualToString:@"https://github.com/login"])
         {
             completionHandler ([NSNumber numberWithBool:YES]);
         }else
         {
             NSNumber * isOrNot = (NSNumber *)whatIsThis;
             
             completionHandler (isOrNot);
         }
     }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"switchBoard"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_SWITCH_BOARD" object:nil];
    }
}


@end
