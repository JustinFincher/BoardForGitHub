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
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
//    self.window.acceptsMouseMovedEvents = YES;
//    self.window.movableByWindowBackground = true;
//    self.window.titlebarAppearsTransparent = YES;
//    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
//    self.window.styleMask |= NSWindowStyleMaskResizable;
//    self.window.styleMask |= NSBorderlessWindowMask;
    
    [self updateWindowButtons];
}



-(void)updateWindowButtons
{
    [self removeWindowButtons];
    [self addWindowButtons];
    
}
- (void)removeWindowButtons
{
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *zoomButton = [self.window standardWindowButton:NSWindowZoomButton];
    NSButton *minimizeButton = [self.window standardWindowButton:NSWindowMiniaturizeButton];
    [closeButton removeFromSuperview];
    [zoomButton removeFromSuperview];
    [minimizeButton removeFromSuperview];
}
- (void)addWindowButtons
{
    NSView *containerView = [(JZMainViewController *)(self.contentViewController) windowButtonsContainerView];
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *zoomButton = [self.window standardWindowButton:NSWindowZoomButton];
    NSButton *minimizeButton = [self.window standardWindowButton:NSWindowMiniaturizeButton];
    [containerView addSubview:closeButton];
    [containerView addSubview:zoomButton];
    [containerView addSubview:minimizeButton];
    closeButton.frame = NSMakeRect(10,(containerView.frame.size.height - 16)/2.0f,14,16);
    minimizeButton.frame = NSMakeRect(30,(containerView.frame.size.height - 16)/2.0f,14,16);
    zoomButton.frame = NSMakeRect(50,(containerView.frame.size.height - 16)/2.0f,14,16);
}


#pragma mark - NSWindowDelegate
- (void)windowDidEndLiveResize:(NSNotification *)notification
{
    [self updateWindowButtons];
}
- (void)windowWillStartLiveResize:(NSNotification *)notification
{
//    [self addWindowButtons];
}
- (void)windowDidResize:(NSNotification *)notification
{
    [self updateWindowButtons];
}
- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
//    [self removeWindowButtons];
}
- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    [self updateWindowButtons];
}
- (void)windowWillExitFullScreen:(NSNotification *)notification
{
//    [self removeWindowButtons];
}
- (void)windowDidExitFullScreen:(NSNotification *)notification
{
    [self updateWindowButtons];
}

@end
