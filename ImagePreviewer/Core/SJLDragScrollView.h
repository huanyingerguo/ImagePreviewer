//
//  SJLDragScrollView.h
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/13.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJLDragScrollView : NSScrollView
@property (assign) BOOL  isAutoAdjust;

- (void)registerGesture;
- (void)zoomContentViweByValuue:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
