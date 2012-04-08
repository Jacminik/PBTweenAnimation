/*
 
 These timing functions are adapted from Robert Penner's excellent AS2 easing equations.
 For more information, check out http://robertpenner.com/easing/
 
 --
 
 TERMS OF USE - EASING EQUATIONS
 
 Open source under the BSD License. 
 
 Copyright © 2001 Robert Penner
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

CG_EXTERN CGPoint CGRectGetCenter(CGRect rect);

#define IPHONE_FRAME_RATE 60.0f

typedef enum {
    PBTweenFunctionNon              = 00,   // Liner
    
    PBTweenFunctionQuadEaseIn       = 10,
    PBTweenFunctionQuadEaseOut      = 11,
    PBTweenFunctionQuadEaseInOut    = 12,
    
    PBTweenFunctionCubicEaseIn      = 20,
    PBTweenFunctionCubicEaseOut     = 21,
    PBTweenFunctionCubicEaseInOut   = 22,
    
    PBTweenFunctionQuartEaseIn      = 30,
    PBTweenFunctionQuartEaseOut     = 31,
    PBTweenFunctionQuartEaseInOut   = 32,
    
    PBTweenFunctionQuintEaseIn      = 40,
    PBTweenFunctionQuintEaseOut     = 41,
    PBTweenFunctionQuintEaseInOut   = 42,
    
    PBTweenFunctionSineEaseIn       = 50,
    PBTweenFunctionSineEaseOut      = 51,
    PBTweenFunctionSineEaseInOut    = 52,
    
    PBTweenFunctionExpoEaseIn       = 60,
    PBTweenFunctionExpoEaseOut      = 61,
    PBTweenFunctionExpoEaseInOut    = 62,
    
    PBTweenFunctionCircEaseIn       = 70,
    PBTweenFunctionCircEaseOut      = 71,
    PBTweenFunctionCircEaseInOut    = 72,
    
    PBTweenFunctionElasticEaseIn    = 80,
    PBTweenFunctionElasticEaseOut   = 81,
    PBTweenFunctionElasticEaseInOut = 82,
    
    PBTweenFunctionBackEaseIn       = 90,
    PBTweenFunctionBackEaseOut      = 91,
    PBTweenFunctionBackEaseInOut    = 92,
    
    PBTweenFunctionBounceEaseIn     = 100,
    PBTweenFunctionBounceEaseOut    = 101,
    PBTweenFunctionBounceEaseInOut  = 102,
} PBTweenFunction;

/***************************** アニメーションカーブのレベル(1 < 10)
 Linear
 Quadratic		// 4
 Cubic			// 6
 Quartic			// 7
 Quintic			// 8
 Sinusoidal		// 2 (最も緩い)
 Exponential		// 9 (最も急)
 Circular		// 5 (自然な放物線)
 Elastic			// ゴムのような反発。endValueを超えて跳ねる     ex)EaseOut
 Back			// 低反発。endValueを超えて戻る。(跳ねない)        ex)EaseOut
 Bounce			// コンクリートに当たったようなバウンス。endValue以上はいかない   ex)EaseOut
 *****************************************************************/


NSArray *TweenedValues(PBTweenFunction function, double startValue, double endValue, double duration);
NSArray *TweenedCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration);
NSArray *TweenedCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration);
NSArray *TweenedCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration);
NSArray *TweenedRadianValues(PBTweenFunction function, double startValue, double endValue, double duration);


// Fade
CAKeyframeAnimation *PBTweenAnimationTypeOpacity(CGFloat startOpacity, CGFloat endOpacity, 
                                                 CFTimeInterval duration, PBTweenFunction function);
// Scale
CAKeyframeAnimation *PBTweenAnimationTypeScale(CGFloat startScale, CGFloat endScale, 
                                               CFTimeInterval duration, PBTweenFunction function);
// Move
CAKeyframeAnimation *PBTweenAnimationTypePosition(CGPoint startPosition, CGPoint endPosition, 
                                                  CFTimeInterval duration, PBTweenFunction function);
// Resize
CAKeyframeAnimation *PBTweenAnimationTypeSize(CGSize startSize, CGSize endSize, 
                                              CFTimeInterval duration, PBTweenFunction function);
// Rotation(Axis:z)
CAKeyframeAnimation *PBTweenAnimationType2DRotate(double startDegrees, double endDegrees, 
                                                  CFTimeInterval duration, PBTweenFunction function);
// Rotate vertical or horizonal
CAKeyframeAnimation *PBTweenAnimationType3DRotate(double startDegrees, double endDegrees, 
                                                  CFTimeInterval duration, PBTweenFunction function, BOOL isVertical);
// Rotate vertical or horizonal. with perspective.
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithLayer(CALayer *animLayer, CGFloat zDistance,
                                                           double startDegrees, double endDegrees, CFTimeInterval duration, 
                                                           PBTweenFunction function, BOOL isVertical);
// Frame (CAAnimationGroup)
CAAnimation *PBTweenAnimationTypeFrame(CGRect startFrame, CGRect endFrame, 
                                       CFTimeInterval duration, PBTweenFunction function);

#pragma mark - Elastic & Back with option

NSArray *ElasticValues(PBTweenFunction function, double startValue, double endValue, double duration, double amplitude, double period);
NSArray *ElasticCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration, double amplitude, double period);
NSArray *ElasticCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration, double amplitude, double period);
NSArray *ElasticCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration, double amplitude, double period);
NSArray *ElasticRadianValues(PBTweenFunction function, double startValue, double endValue, double duration, double amplitude, double period);

NSArray *BackValues(PBTweenFunction function, double startValue, double endValue, double duration, double overshoot);
NSArray *BackCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration, double overshoot);
NSArray *BackCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration, double overshoot);
NSArray *BackCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration, double overshoot);
NSArray *BackRadianValues(PBTweenFunction function, double startValue, double endValue, double duration, double overshoot);

// Elastic option: use amplitude(Default:0.0), period(Default:0.0)
/*
 amplitude (optional) <振幅の大きさ>
 period (optional) <値が大きいほど反発を吸収する>
 */
// Back option: use overshoot(Default:1.70158)
/*
 overshoot <始点／終点を超える量> 1.70158 = 10%
 */
CAKeyframeAnimation *PBTweenAnimationTypeOpacityWithOption(CGFloat startOpacity, CGFloat endOpacity, 
                                                           CFTimeInterval duration, PBTweenFunction function, 
                                                           double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationTypeScaleWithOption(CGFloat startScale, CGFloat endScale, 
                                                         CFTimeInterval duration, PBTweenFunction function, 
                                                         double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationTypePositionWithOption(CGPoint startPosition, CGPoint endPosition, 
                                                            CFTimeInterval duration, PBTweenFunction function, 
                                                            double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationTypeSizeWithOption(CGSize startSize, CGSize endSize, 
                                                        CFTimeInterval duration, PBTweenFunction function, 
                                                        double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationType2DRotateWithOption(double startDegrees, double endDegrees, 
                                                            CFTimeInterval duration, PBTweenFunction function, 
                                                            double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithOption(double startDegrees, double endDegrees, 
                                                            CFTimeInterval duration, PBTweenFunction function, BOOL isVertical, 
                                                            double amplitude, double period, double overshoot);
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithLayerWithOption(CALayer *animLayer, CGFloat zDistance,
                                                                     double startDegrees, double endDegrees, CFTimeInterval duration, 
                                                                     PBTweenFunction function, BOOL isVertical, 
                                                                     double amplitude, double period, double overshoot);
CAAnimation *PBTweenAnimationTypeFrameWithOption(CGRect startFrame, CGRect endFrame, 
                                                 CFTimeInterval duration, PBTweenFunction function, 
                                                 double amplitude, double period, double overshoot);

