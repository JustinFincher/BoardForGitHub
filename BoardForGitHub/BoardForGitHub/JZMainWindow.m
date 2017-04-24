//
//  JZMainWindow.m
//  BoardForGitHub
//
//  Created by Justin Fincher on 2016/11/29.
//  Copyright © 2016年 Justin Fincher. All rights reserved.
//

#import "JZMainWindow.h"

@interface JZMainWindow()

@property (assign) NSPoint initialLocation;

@end

@implementation JZMainWindow

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

- (void)sendEvent:(NSEvent *)theEvent
{
    [super sendEvent:theEvent];
    if ([theEvent type] == NSLeftMouseDown || [theEvent type] == NSLeftMouseDragged)
    {
        if ([theEvent locationInWindow].y < [theEvent window].frame.size.height - 50.0f)
        {
            return;
        }
    }
    if ([theEvent type] == NSLeftMouseDown)
    {
        [self mouseDown:theEvent];
    }
    else if ([theEvent type] == NSLeftMouseDragged)
    {
        [self mouseDragged:theEvent];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    self.initialLocation = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSPoint newOrigin;
    
    NSRect  screenFrame = [[NSScreen mainScreen] frame];
    NSRect  windowFrame = [self frame];
    
    currentLocation = [NSEvent mouseLocation];
    newOrigin.x = currentLocation.x - self.initialLocation.x;
    newOrigin.y = currentLocation.y - self.initialLocation.y;
    
    // Don't let window get dragged up under the menu bar
    if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
        newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
    }
    
    //go ahead and move the window to the new location
    [self setFrameOrigin:newOrigin];
}

@end
