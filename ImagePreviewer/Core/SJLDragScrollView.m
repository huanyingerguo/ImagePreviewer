//
//  SJLDragScrollView.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/13.
//

#import "SJLDragScrollView.h"
#import <Masonry/Masonry.h>

@interface SJLDragScrollView ()
@property (strong) NSPanGestureRecognizer *panGesture;
@end


@implementation SJLDragScrollView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    self.allowsMagnification = YES;
    self.panGesture = [[NSPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan2:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(magnifyDidChangeNotification:) name:NSScrollViewDidEndLiveMagnifyNotification object:nil];
    [self adaptiveDocumentView];
    [self udpateCursor];
}

/*
- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowsMagnification = YES;
        self.panGesture = [[NSPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan2:)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(magnifyDidChangeNotification:) name:NSScrollViewDidEndLiveMagnifyNotification object:nil];
        [self adaptiveDocumentView];
        [self udpateCursor];
    }
    
    return self;
}
 */

- (void)registerGesture {
    [self addGestureRecognizer:self.panGesture];
}

- (void)deRigisterGesture {
    [self removeGestureRecognizer:self.panGesture];
}

- (void)magnifyGestureRec:(NSMagnificationGestureRecognizer *)gesture {
    NSGestureRecognizerState state = gesture.state;
    if (state == NSGestureRecognizerStateEnded) {
        CGFloat value = (1.0 + gesture.magnification);
        [self zoomContentViewByValue:value];
    }
}

-(void)handlePan2:(NSPanGestureRecognizer*)rec{
    if (self.isAutoAdjust) { //过滤非必要的操作
        return;
    }
    
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

- (void)magnifyDidChangeNotification:(NSNotification *)notification {
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
    
    if (self.magnifyChanged) {
        self.magnifyChanged();
    }
    
    [self udpateCursor];
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
    [self setMagnification:(manification + value) centeredAtPoint:center];
    
    [self udpateCursor];
}

- (void)adaptiveDocumentView {
    if (!self.isAutoAdjust) {
        self.isAutoAdjust = YES;
        [self.documentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.documentView.superview);
        }];
    }
    
    [self setMagnification:1.0];
    [self udpateCursor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Cursor
- (void)udpateCursor {
    if ([self isCanScroll]) {
        [self registerGesture];
        self.documentCursor = [NSCursor closedHandCursor];
        //[[NSCursor closedHandCursor] set];
        //[self addCursorRect:self.bounds cursor:[NSCursor closedHandCursor]];
    } else {
        [self deRigisterGesture];
        self.documentCursor = [NSCursor arrowCursor];
        //[[NSCursor arrowCursor] set];
        //[self addCursorRect:self.bounds cursor:[NSCursor arrowCursor]];
    }
}

- (BOOL)isCanScroll {
    NSSize contentBounds = self.contentView.bounds.size;
    NSSize imageSize = self.documentView.bounds.size;
    if (imageSize.width > contentBounds.width ||
        imageSize.height > contentBounds.height) {
        return YES;
    }
    
    return NO;
}
@end
