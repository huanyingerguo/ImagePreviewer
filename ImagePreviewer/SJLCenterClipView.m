//
//  SJLCenterClipView.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/13.
//

#import "SJLCenterClipView.h"

#define Max(a,b) ( ((a) > (b)) ? (a) : (b) )

@implementation SJLCenterClipView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSRect)constrainBoundsRect:(NSRect)proposedBounds {
    NSRect base = [super constrainBoundsRect:proposedBounds];
    NSRect documentFrame = self.documentView.frame;
    if (NSEqualRects(documentFrame, NSZeroRect)) {
        return base;
    }
    
    NSRect frame = self.frame;
    CGFloat mag = frame.size.width / proposedBounds.size.width;
    NSEdgeInsets insets = self.enclosingScrollView.contentInsets;
    
    CGFloat deltaX = Max(frame.size.width / mag - documentFrame.size.width, 0.0);
    CGFloat deltaY = Max(frame.size.height / mag-insets.top / mag - documentFrame.size.height, 0.0);
    
    NSRect ret = base;
    ret.origin.x -= deltaX/2.0;
    ret.origin.y -= deltaY/2.0;
    
    return ret;
}

@end
