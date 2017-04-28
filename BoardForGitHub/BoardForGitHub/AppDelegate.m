//
//  AppDelegate.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/28.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "AppDelegate.h"
#import "JZMainWindow.h"
#import "JZMainViewController.h"
#import "JZSettingsWindowController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import WebKit;

@interface AppDelegate ()<NSUserNotificationCenterDelegate>
@property (strong,nonatomic) JZMainWindow *mainWindow;
@property (strong,nonatomic) JZSettingsWindowController *settingsWindowController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"NSApplicationCrashOnExceptions": @YES }];
    [Fabric with:@[[Crashlytics class]]];
    
    self.mainWindow = (JZMainWindow *)[[NSApplication sharedApplication] mainWindow];
    JZMainViewController *controller = (JZMainViewController *)self.mainWindow.contentViewController;
    [NSApp setServicesProvider:controller];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JZ_OPEN_SETTINGS:) name:@"JZ_OPEN_SETTINGS" object:nil];
     [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}
- (void)JZ_OPEN_SETTINGS:(NSNotification *)notif
{
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    self.settingsWindowController = [storyBoard instantiateControllerWithIdentifier:@"JZSettingsWindowController"];
    [self.settingsWindowController.window makeKeyAndOrderFront:self];
}
#pragma mark - Menus Buttons
- (IBAction)reloadBoardButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_RELOAD_BOARD" object:nil];
}
- (IBAction)revertBoardButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_REVERT_BOARD" object:nil];
}
- (IBAction)forwardBoardButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_FORWARD_BOARD" object:nil];
}


- (IBAction)openButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_SWITCH_BOARD" object:nil];
}
- (IBAction)showBoardMenuPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_SHOW_BOARD_MENU" object:nil];
}
- (IBAction)addCardsFromPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_ADD_CARDS_FROM" object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)clearCookie:(id)sender
{
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records)
                         {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                    }];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_RELOAD_BOARD" object:nil];
                         }
                     }];
}
- (BOOL)application:(NSApplication *)sender
           openFile:(NSString *)filename
{
    return YES;
}


#pragma mark - NSUserNotificationCenterDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    switch (notification.activationType)
    {
        case NSUserNotificationActivationTypeActionButtonClicked:
        {
            [[NSPasteboard generalPasteboard] clearContents];
            [[NSPasteboard generalPasteboard] setString:notification.informativeText forType:NSStringPboardType];
        }
            break;
        default:
            break;
    }
}
@end
