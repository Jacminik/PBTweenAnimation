//
//  PBViewController.m
//  PBTweenDemo
//
//  Created by masahiro.k on 12/04/02.
//  Copyright (c) 2012年 +Beans. All rights reserved.
//

#import "PBViewController.h"
#import "PBTweenAnimation.h"

@interface PBViewController ()

@end

@implementation PBViewController {
    
    IBOutlet UIView *_controlView;
    IBOutlet UILabel *_label;
    IBOutlet UISegmentedControl *_easeSegment;
    IBOutlet UISegmentedControl *_animSegment;
    IBOutlet UIPickerView *_picker;
    IBOutlet UIButton *_doneButton;
    
    __strong NSArray *_tweenNames;
    PBTweenFunction _function;
    PBAnimationStyle _animStyle;
    
    __strong CALayer *_animLayer;
    __strong UIButton *_startButton, *_settingButton;
}


- (void)setting {
    
    _tweenNames = [NSArray arrayWithObjects:@"Nomal ※Easeなし", @"Quad (4)", @"Cubic (6)", @"Quart (7)", @"Quint (8)", @"Sine (2)※最も緩やか", @"Expo (9)※最も急", @"Circ (5)※自然な変化", @"Elastic ※ゴム", @"Back ※吸収", @"Bounce ※ブロック", nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setting];
    } return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect doneFrame = _doneButton.frame;
    doneFrame.origin.y += CGRectGetMinY(_controlView.frame);
    CGFloat width = 135.0f;
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _settingButton.frame = CGRectMake(doneFrame.origin.x, doneFrame.origin.y,
                                     width, doneFrame.size.height);
    [_settingButton setTitle:@"設定" forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(settingButtonTapped) 
           forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_settingButton belowSubview:_controlView];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _startButton.bounds = _settingButton.bounds;
    _startButton.center = CGPointMake(_settingButton.center.x + width + 10.0f, _settingButton.center.y);
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(beginAnimation) 
           forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_startButton belowSubview:_controlView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 11;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_tweenNames objectAtIndex:row];
}


- (void)updateLabel {
    
//    NSLog(@"")
    NSString *tweenName = [_tweenNames objectAtIndex:[_picker selectedRowInComponent:0]];
    NSRange range = 
    [tweenName rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    tweenName = [tweenName substringWithRange:NSMakeRange(0, range.location)];
    
    NSString *type = nil;
    switch (_easeSegment.selectedSegmentIndex) {
        case 0:
            type = @"EaseIn";break;
        case 1:
            type = @"EaseOut";break;
        case 2:
            type = @"EaseInOut";break;
    }
    NSString *anim = nil;
    switch (_animSegment.selectedSegmentIndex) {
        case 0:
            anim = @"Opacity";break;
        case 1:
            anim = @"Scale";break;
        case 2:
            anim = @"Position";break;
        case 3:
            anim = @"Bounds";break;
        case 4:
            anim = @"Rotate(z)";break;
        case 5:
            anim = @"Rotate(x)";break;
    }
    
    _label.text = [NSString stringWithFormat:@"PBTween%@%@(%@)", tweenName, type, anim];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateLabel];
}
- (IBAction)didValueChanged:(UISegmentedControl *)segnment {
    [self updateLabel];
}
- (IBAction)doneButtonTapped {
    
    _function = ([_picker selectedRowInComponent:0] * 10) + _easeSegment.selectedSegmentIndex;
    _animStyle = _animSegment.selectedSegmentIndex;
    NSLog(@"function:%d, animStyle:%d", _function, _animStyle);
    
    [self updateLabel];
    
    __block id __self = self;
    __block UIView *__controlView = _controlView;
    [UIView animateWithDuration:0.375f delay:0.f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGPoint endPoint = __controlView.center;
                         endPoint.y += __controlView.bounds.size.height;
                         __controlView.center = endPoint;
                         __controlView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         [__self addAnimationLayer];
                     }];
}

- (void)settingButtonTapped {
    
    [_animLayer removeFromSuperlayer];
    _animLayer = nil;
    
    __block UIView *__controlView = _controlView;
    [UIView animateWithDuration:0.375f delay:0.f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         CGPoint endPoint = __controlView.center;
                         endPoint.y -= __controlView.bounds.size.height;
                         __controlView.center = endPoint;
                         __controlView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - TweenAnimations

#define FROM_RECT_ROTATE CGRectMake(40.0f, 70.0f, 240.0f, 240.0f)
#define FROM_RECT_SCALE CGRectMake(110.0f, 140.0f, 100.0f, 100.0f)
#define FROM_BOUNDS_MOVE CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)

#define FROM_CENTER CGPointMake(60.0f, 90.0f)
#define TO_CENTER CGPointMake(240.0f, 290.0f)

#define TO_RECT CGRectMake(100.0f, 240.0f, 200.0f, 100.0f)

- (void)addAnimationLayer {
    
    _animLayer = [CALayer new];
    _animLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    if (_animStyle == PBAnimationStyleOpacity || _animStyle >= PBAnimationStyleBounds) {
        _animLayer.frame = FROM_RECT_ROTATE;
        _animLayer.cornerRadius = 10.0f;
    }
    else if (_animStyle == PBAnimationStyleScale) {
        _animLayer.frame = FROM_RECT_SCALE;
        _animLayer.cornerRadius = 10.0f;
    }
    else {      // Position
        _animLayer.bounds = FROM_BOUNDS_MOVE;
        _animLayer.position = FROM_CENTER;
        _animLayer.cornerRadius = floorf(_animLayer.bounds.size.width * 0.5f);
    }
    [self.view.layer addSublayer:_animLayer];
}

- (void)beginAnimation {
    
    CFTimeInterval duratin = kAnimDuration;
    
    CAAnimation *anim = nil;
    switch (_animStyle) {
        case PBAnimationStyleOpacity:
            anim = PBTweenAnimationTypeOpacity(1.0f, 0.f, duratin, _function);
            break;
        case PBAnimationStyleScale:
            anim = PBTweenAnimationTypeScale(1.0f, 3.0f, duratin, _function);
            break;
        case PBAnimationStylePosition:
            anim = PBTweenAnimationTypePosition(FROM_CENTER, TO_CENTER, duratin, _function);
            break;
        case PBAnimationStyleBounds:
            anim = PBTweenAnimationTypeFrame(FROM_RECT_ROTATE, TO_RECT, duratin, _function);
//            anim = PBTweenAnimationTypeSize(FROM_RECT_ROTATE.size, TO_RECT.size, duratin, _function);
            break;
        case PBAnimationStyleRotate2D:
            anim = PBTweenAnimationType2DRotate(0.f, 360.0f, duratin, _function);
            break;
        case PBAnimationStyleRotate3D:
            anim = PBTweenAnimationType3DRotateWithLayer(_animLayer, 1.0f, 0.f, 180.0f, duratin, _function, YES);
            break;
        default:
            break;
    }
    [_animLayer addAnimation:anim forKey:nil];
    
}

@end


