//
//  HoverView.m
//  Mac Hi
//
//  Created by MacWrs on 15/5/3.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "HoverView.h"

@interface HoverView()
@property NSTrackingArea* trackingArea;

@end

@implementation HoverView

- (void) refreshTrackingArea {
    if(self.trackingArea != nil) {
        [self removeTrackingArea:self.trackingArea];
    }
    int opts = (NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways|NSTrackingAssumeInside|NSTrackingMouseMoved);
    self.trackingArea = [ [NSTrackingArea alloc] initWithRect:self.bounds
                                                      options:opts
                                                        owner:self
                                                     userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    
    [self checkMouseLocation];
    
    [self refreshTrackingArea];
}

//判定鼠标是否在当前视图内
- (BOOL)mouseInView {
    if (!self.window)
        return NO;
    if (self.isHidden)
        return NO;
    
    NSPoint point = [NSEvent mouseLocation];
    point = [self.window convertRectFromScreen:NSMakeRect(point.x, point.y, 0, 0)].origin;
    point = [self convertPoint:point fromView:nil];
    return NSPointInRect(point, self.visibleRect);
}

- (void)checkMouseLocation {
    if ([self mouseInView]) {
        if (self.actionEnabled &&  self.mouseEnteredBlock) {
            self.mouseEnteredBlock(nil);
        }
    } else {
        if (self.actionEnabled &&  self.mouseExitedBlock) {
            self.mouseExitedBlock(nil);
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    if (self.actionEnabled && self.mouseEnteredBlock) {
        self.mouseEnteredBlock(theEvent);
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    if (self.actionEnabled && self.mouseExitedBlock) {
        self.mouseExitedBlock(theEvent);
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self processMouseDrag:self];
    if (self.actionEnabled && self.mouseDownBlock) {
        self.mouseDownBlock(theEvent);
    } else {
        [super mouseDown:theEvent];
    }
}

-(void)mouseMoved:(NSEvent *)theEvent{
    [super mouseMoved:theEvent];
    if (self.actionEnabled && self.mouseMovedBlock){
        self.mouseMovedBlock(theEvent);
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    if (self.actionEnabled && self.mouseUpBlock) {
        self.mouseUpBlock(theEvent);
    }
}

- (void)rightMouseDown:(NSEvent *)event {
    if (self.actionEnabled && self.rightMouseDownBlock) {
        self.rightMouseDownBlock(event);
    } else {
        [super rightMouseDown:event];
    }
}

- (BOOL)actionEnabled {
    return !self.eventDisabled;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%p", self];
    if (self.viewName.length) {
        desc = [NSString stringWithFormat:@"%p:name=%@, isHidden=%d", self, self.viewName, self.isHidden];
    }
    
    return desc;
}

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

- (void)processMouseDrag:(NSView *)view {
    static id mouseEventMonitor;
    static NSPoint where, origin;
    if ([NSEvent pressedMouseButtons] != NSEventTypeLeftMouseDown) {
        return;
    }
    if (mouseEventMonitor == nil) {
        where = [NSEvent mouseLocation];
        origin = self.window.frame.origin;
        mouseEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDragged | NSEventMaskLeftMouseUp handler:^NSEvent *(NSEvent * event) {
            if (event.type == NSEventTypeLeftMouseUp) {
                if (mouseEventMonitor != nil) {
                    [NSEvent removeMonitor:mouseEventMonitor];
                    mouseEventMonitor = nil;
                }
            } else {
                NSPoint now = [NSEvent mouseLocation];
                origin.x += now.x - where.x;
                origin.y += now.y - where.y;
                [self.window setFrameOrigin:origin];
                where = now;
            }
            return event;
        }];
    }
}

@end
