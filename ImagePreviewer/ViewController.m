//
//  ViewController.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/8.
//

#import "ViewController.h"
#import "HandCursorImageView.h"
#import <Masonry.h>

@interface ViewController()
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet HandCursorImageView *imageView;
@property (weak) IBOutlet NSButton *modeBtn;
@property (assign) BOOL  isAutoAdjust;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;

    [self registerGesture];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)registerGesture {
//    NSMagnificationGestureRecognizer *gesture = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyGestureRec:)];
//    [self.scrollView addGestureRecognizer:gesture];
    
    NSPanGestureRecognizer *pan = [[NSPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan2:)];
    [self.imageView addGestureRecognizer:pan];
    self.scrollView.allowsMagnification = YES;
}

- (void)magnifyGestureRec:(NSMagnificationGestureRecognizer *)gesture {
    NSGestureRecognizerState state = gesture.state;
    if (state == NSGestureRecognizerStateEnded) {
        CGFloat value = (1.0 + gesture.magnification);
        [self zoomContentViweByValuue:value];
    }
}

-(void)handlePan:(NSPanGestureRecognizer*)rec{
    NSView *contentView = self.imageView;
    NSPoint point = [rec locationInView:self.scrollView];
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

-(void)handlePan2:(NSPanGestureRecognizer*)rec{
    NSView *contentView = self.scrollView.contentView;
    NSPoint point = [rec locationInView:self.scrollView];
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

- (void)scrollWheel:(NSEvent *)event {
    
}


#pragma mark- IBAction
- (IBAction)onModeBtnCliked:(NSButton *)sender {
    if (!self.isAutoAdjust) {
        self.isAutoAdjust = YES;
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView.superview);
        }];
    }
    
    [self.scrollView setMagnification:1.0];
}

- (IBAction)onZoomInBtnCliked:(NSButton *)sender {
    CGFloat value = (1.0 + 0.25);
    [self zoomContentViweByValuue:value];
}

- (IBAction)onZoomOutBtnCliked:(NSButton *)sender {
    CGFloat value = (1.0 - 0.25);
    [self zoomContentViweByValuue:value];
}

- (void)zoomContentViweByValuue:(CGFloat)value {
    if (self.isAutoAdjust) {
        self.isAutoAdjust = NO;
        NSSize lastSize = self.imageView.frame.size;
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
             make.centerY.mas_equalTo(self.scrollView.mas_centerY);
             make.centerX.mas_equalTo(self.scrollView.mas_centerX);
             make.width.mas_equalTo(lastSize.width * value);
             make.height.mas_equalTo(lastSize.height * value);
        }];
    }

    NSRect bounds = self.scrollView.documentVisibleRect;
    NSPoint center = NSMakePoint(NSMidX(bounds), NSMidY(bounds));
    center = [self.scrollView.contentView convertPoint:center fromView:self.scrollView.documentView];
    
    CGFloat manification = self.scrollView.magnification;
    [self.scrollView setMagnification:manification * value centeredAtPoint:center];
}

@end
