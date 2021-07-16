//
//  SJLDragScrollView.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/13.
//

#import "SJLDragScrollView.h"
#import <Masonry/Masonry.h>

@implementation SJLDragScrollView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)registerGesture {
//    NSMagnificationGestureRecognizer *gesture = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyGestureRec:)];
//    [self.scrollView addGestureRecognizer:gesture];
    
    NSPanGestureRecognizer *pan = [[NSPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan2:)];
    [self addGestureRecognizer:pan];
    self.allowsMagnification = YES;
    
    self.backgroundColor = [NSColor colorWithRed:0 green:1 blue:0 alpha:1];
}

- (void)magnifyGestureRec:(NSMagnificationGestureRecognizer *)gesture {
    NSGestureRecognizerState state = gesture.state;
    if (state == NSGestureRecognizerStateEnded) {
        CGFloat value = (1.0 + gesture.magnification);
        [self zoomContentViewByValue:value];
    }
}

/*
-(void)handlePan:(NSPanGestureRecognizer*)rec{
    NSView *contentView = self.documentView;
    NSPoint point = [rec locationInView:self];
    static CGFloat xDistance = 0.0f;
    static CGFloat yDistance = 0.0f;
   
    if(rec.state == NSGestureRecognizerStateBegan){
        NSPoint origin = contentView.frame.origin;
        xDistance = origin.x - point.x;
        yDistance = origin.y - point.y;
    }
    else if(rec.state == NSGestureRecognizerStateEnded){
    }
    else{
        NSPoint origin = NSMakePoint(point.x+xDistance, point.y+yDistance);
        NSRect rect = contentView.frame;
        rect.origin = origin;
        [contentView setFrame:rect];
    }
}
 */

-(void)handlePan2:(NSPanGestureRecognizer*)rec{
    NSView *contentView = self.contentView;
    NSPoint point = [rec locationInView:self];
    static NSPoint beginPoint;
    static NSPoint origin;

    if(rec.state == NSGestureRecognizerStateBegan){
        beginPoint = point;
        origin = contentView.bounds.origin;
    }
    else if(rec.state == NSGestureRecognizerStateEnded){
    }
    else{
        NSPoint new = NSMakePoint(origin.x - (point.x - beginPoint.x), origin.y + point.y - beginPoint.y);
        [contentView setBoundsOrigin:new];
    }
}

- (void)zoomContentViewByValue:(CGFloat)value {
    if (self.isAutoAdjust) {
        self.isAutoAdjust = NO;
        NSSize lastSize = self.frame.size;
        [self.documentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(lastSize.width);
            make.height.mas_equalTo(lastSize.height);
        }];
    }

    NSRect bounds = self.documentVisibleRect;
    NSPoint center = NSMakePoint(NSMidX(bounds), NSMidY(bounds));
    center = [self.contentView convertPoint:center fromView:self.documentView];
    
    CGFloat manification = self.magnification;
    [self setMagnification:manification * value centeredAtPoint:center];
}

- (void)adatptiveDocumentView {
    if (!self.isAutoAdjust) {
        self.isAutoAdjust = YES;
        [self.documentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.documentView.superview);
        }];
    }
    
    [self setMagnification:1.0];
}
@end
