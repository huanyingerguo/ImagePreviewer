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

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
    [self.scrollView registerGesture];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark- IBAction
- (IBAction)onModeBtnCliked:(NSButton *)sender {
    if (!self.scrollView.isAutoAdjust) {
        self.scrollView.isAutoAdjust = YES;
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView.superview);
        }];
    }
    
    [self.scrollView setMagnification:1.0];
}

- (IBAction)onZoomInBtnCliked:(NSButton *)sender {
    CGFloat value = (1.0 + 0.25);
    [self.scrollView zoomContentViweByValuue:value];
}

- (IBAction)onZoomOutBtnCliked:(NSButton *)sender {
    CGFloat value = (1.0 - 0.25);
    [self.scrollView zoomContentViweByValuue:value];
}


@end
