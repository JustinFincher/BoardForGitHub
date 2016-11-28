//
//  JZWindowController.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "JZWindowController.h"
#import "JZMainViewController.h"

@interface JZWindowController ()<NSWindowDelegate>



@end

@implementation JZWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.delegate = self;
    
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.acceptsMouseMovedEvents = YES;
    [self.window setMovableByWindowBackground:YES];
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    self.window.styleMask |= NSWindowStyleMaskResizable;
    
    [self moveWindowButtons];
}



-(void)moveWindowButtons
{
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *zoomButton = [self.window standardWindowButton:NSWindowZoomButton];
    NSButton *minimizeButton = [self.window standardWindowButton:NSWindowMiniaturizeButton];
    
    [closeButton removeFromSuperview];
    [zoomButton removeFromSuperview];
    [minimizeButton removeFromSuperview];
    
    [[(JZMainViewController *)(self.contentViewController) windowButtonsContainerView] addSubview:closeButton];
    [[(JZMainViewController *)(self.contentViewController) windowButtonsContainerView] addSubview:zoomButton];
    [[(JZMainViewController *)(self.contentViewController) windowButtonsContainerView] addSubview:minimizeButton];
    
    closeButton.frame = NSMakeRect(10,17,14,16);
    minimizeButton.frame = NSMakeRect(30,17,14,16);
    zoomButton.frame = NSMakeRect(50,17,14,16);
}

#pragma mark - NSWindowDelegate
- (void)windowDidResize:(NSNotification *)notification
{
    [self moveWindowButtons];
}

@end
