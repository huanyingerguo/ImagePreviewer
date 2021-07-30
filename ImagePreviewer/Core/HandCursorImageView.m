//
//  HandCursorImageView.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/9.
//

#import "HandCursorImageView.h"

@interface HandCursorImageView ()
@property (assign) BOOL isMousedown;
@end

@implementation HandCursorImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    self.isMousedown = YES;
    [super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
    self.isMousedown = NO;
    [super mouseUp:event];
}

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}
@end
