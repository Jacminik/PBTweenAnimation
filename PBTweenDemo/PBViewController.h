//
//  PBViewController.h
//  PBTweenDemo
//
//  Created by masahiro.k on 12/04/02.
//  Copyright (c) 2012年 +Beans. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimDuration 1.0f

typedef enum {
    PBAnimationStyleOpacity     = 0,
    PBAnimationStyleScale       = 1,
    PBAnimationStylePosition    = 2,
    PBAnimationStyleBounds      = 3,
    PBAnimationStyleRotate2D    = 4,
    PBAnimationStyleRotate3D    = 5,
} PBAnimationStyle;

@interface PBViewController : UIViewController 



- (IBAction)didValueChanged:(UISegmentedControl *)segnment;
- (IBAction)doneButtonTapped;

@end

