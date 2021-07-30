//
//  HoverView.h
//  Mac Hi
//
//  Created by MacWrs on 15/5/3.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^EventBlock)(NSEvent *theEvent);

@interface HoverView : NSView
@property (nonatomic, copy) NSString *viewName;
@property (nonatomic, assign) BOOL canMoveWindow;
@property (nonatomic, assign) BOOL eventDisabled; //事件不可用
@property (nonatomic, copy) EventBlock mouseEnteredBlock;
@property (nonatomic, copy) EventBlock mouseExitedBlock;
@property (nonatomic, copy) EventBlock mouseDownBlock;
@property (nonatomic, copy) EventBlock mouseUpBlock;
@property (nonatomic, copy) EventBlock mouseMovedBlock;
@property (nonatomic, copy) EventBlock rightMouseDownBlock;
@end
