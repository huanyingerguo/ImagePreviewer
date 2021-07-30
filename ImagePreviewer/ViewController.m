//
//  ViewController.m
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/8.
//

#import "ViewController.h"
#import "SJLDragScrollView.h"
#import "HandCursorImageView.h"
#import <Masonry.h>

@interface ViewController()
@property (weak) IBOutlet SJLDragScrollView *scrollView;
@property (weak) IBOutlet HandCursorImageView *imageView;
@property (weak) IBOutlet NSButton *modeBtn;
@property (weak) IBOutlet NSView *testView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view.window setMovable:YES];
    [self.view.window setAcceptsMouseMovedEvents:YES];
    [self.view.window setMovableByWindowBackground:YES];

    // Do any additional setup after loading the view.
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [[NSColor colorWithRed:1 green:0 blue:0 alpha:1] CGColor];
    self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [self.scrollView registerGesture];
    //self.scrollView.contentView.backgroundColor = [NSColor colorWithRed:0 green:0 blue:1 alpha:1];
    
    //[self addSubview];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)addSubview {
    /*
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor redColor] CGColor];
    self.testView = view;
    
    NSView *superView = self.scrollView.superview;
    [superView addSubview:view positioned:NSWindowAbove relativeTo:self.scrollView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(superView.mas_width);
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(superView.mas_bottom).offset(-40);
        make.left.mas_equalTo(superView.mas_left);
    }];
    [self.testView setHidden:YES];
     */
}


#pragma mark- IBAction
- (IBAction)onModeBtnCliked:(NSButton *)sender {
    [self.scrollView adaptiveDocumentView];
}

- (IBAction)onZoomInBtnCliked:(NSButton *)sender {
    CGFloat value = 0.25;
    [self.scrollView zoomContentViewByValue:value];
}

- (IBAction)onZoomOutBtnCliked:(NSButton *)sender {
    CGFloat value = - 0.25;
    [self.scrollView zoomContentViewByValue:value];
}

- (IBAction)onExpandBtnCliked:(NSButton *)sender {
    if (sender.tag == 0) {
        sender.tag = 1;
        NSView *superView = self.scrollView.superview;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(superView.mas_width);
            make.height.mas_equalTo(120);
            make.bottom.mas_equalTo(superView.mas_bottom).offset(-160);
            make.left.mas_equalTo(superView.mas_left);
        }];
        
        [self.testView setHidden:NO];
    } else {
        sender.tag = 0;
        NSView *superView = self.scrollView.superview;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(superView.mas_width);
            make.height.mas_equalTo(120);
            make.bottom.mas_equalTo(superView.mas_bottom).offset(-40);
            make.left.mas_equalTo(superView.mas_left);
        }];
        
        [self.testView setHidden:YES];
    }
}


@end
