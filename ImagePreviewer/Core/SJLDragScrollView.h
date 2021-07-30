//
//  SJLDragScrollView.h
//  ImagePreviewer
//
//  Created by jinglin sun on 2021/7/13.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MagnifyDidChanged) (void);

@interface SJLDragScrollView : NSScrollView
@property (assign) BOOL  isAutoAdjust;
@property (copy) MagnifyDidChanged magnifyChanged;
             
- (void)registerGesture;
- (void)zoomContentViewByValue:(CGFloat)value;
- (void)adaptiveDocumentView;
@end

NS_ASSUME_NONNULL_END
