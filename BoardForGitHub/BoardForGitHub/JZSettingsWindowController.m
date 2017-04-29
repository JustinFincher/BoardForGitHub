//
//  JZSettingsController.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2017/4/29.
//  Copyright © 2017年 Justin Fincher. All rights reserved.
//

#import "JZSettingsWindowController.h"

@interface JZSettingsWindowController ()

@end

@implementation JZSettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    self.window.movableByWindowBackground = true;
    self.window.styleMask |= NSWindowStyleMaskFullSizeContentView;
    self.window.styleMask |= NSBorderlessWindowMask;
}


@end
