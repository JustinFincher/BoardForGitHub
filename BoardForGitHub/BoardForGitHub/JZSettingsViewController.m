//
//  JZSettingsViewController.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2017/4/29.
//  Copyright © 2017年 Justin Fincher. All rights reserved.
//

#import "JZSettingsViewController.h"
#import "JZHeader.h"
#import <MASShortcut/Shortcut.h>

@interface JZSettingsViewController ()
@property (weak) IBOutlet NSButton *vibrancyBackgroundButton;
@property (weak) IBOutlet MASShortcutView *shortcutView;
@end

@implementation JZSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.vibrancyBackgroundButton setState:([[NSUserDefaults standardUserDefaults] boolForKey:NSStringFromJZUserDefaultsType(JZ_USER_DEFAULTS_VIBRANCY_BACKGROUND)] == YES)];
    
    self.shortcutView.associatedUserDefaultsKey = NSStringFromJZUserDefaultsType(JZ_USER_DEFAULTS_SHOW_BOARD_SHORTCUT);
}


- (IBAction)vibrancyBackgroundStateChanged:(NSButton *)sender
{
    bool enabled = ([sender state] == NSOnState);
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:NSStringFromJZUserDefaultsType(JZ_USER_DEFAULTS_VIBRANCY_BACKGROUND)];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromJZNotificationType(JZ_NOTIFICATON_TYPE_RELOAD_BOARD) object:nil];
}

@end
