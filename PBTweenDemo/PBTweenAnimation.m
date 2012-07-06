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


#import "PBTweenAnimation.h"

double radians(float degrees);
double radians(float degrees) {
	return (degrees * M_PI) / 180;
}
NSNumber *radiansToNumber(float degrees);
NSNumber *radiansToNumber(float degrees) {
	return [NSNumber numberWithDouble:radians(degrees)];
}

CG_EXTERN CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


typedef double (^tweenCalcBlock_t)(double t, double b, double c, double d);

double PBEaseOutBounce(double t, double b, double c, double d);
double PBEaseOutBounce(double t, double b, double c, double d) {
    
	if ((t/=d) < (1/2.75))
		return c*(7.5625*t*t) + b;
	else if (t < (2/2.75))
		return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
	else if (t < (2.5/2.75))
		return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
	else
		return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    
}
double PBEaseInBounce(double t, double b, double c, double d);
double PBEaseInBounce(double t, double b, double c, double d) {
	return c - PBEaseOutBounce(d-t, 0, c, d) + b;
}

tweenCalcBlock_t tweenCalcBlock(PBTweenFunction function);
tweenCalcBlock_t tweenCalcBlock(PBTweenFunction function) {
    
    int tweenType = function / 10;
    int easeType = function % 10;
    
    __weak tweenCalcBlock_t resultBlock = nil;
    switch (tweenType) {
        case 0:             // PBTweenFunctionNo(Liner)
            resultBlock = ^(double t, double b, double c, double d){ return c*t/d + b; };
            break;
        case 1:             // PBTweenFunctionQuad
            switch (easeType) {
                case 0:     // EaseIn
                    resultBlock = ^(double t, double b, double c, double d){ return c*(t/=d)*t + b; };
                    break;
                case 1:     // EaseOut
                    resultBlock = ^(double t, double b, double c, double d){ return -c *(t/=d)*(t-2) + b; };
                    break;
                case 2:     // EaseInOut
                    resultBlock = ^(double t, double b, double c, double d){ 
                        if ((t/=d/2) < 1) return c/2*t*t + b;
                        return -c/2 * ((--t)*(t-2) - 1) + b;
                    };
                    break;
            }
            break;
        case 2:             // PBTweenFunctionCubic
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return c*(t/=d)*t*t + b; };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ return c*((t=t/d-1)*t*t + 1) + b; };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if ((t/=d/2) < 1) return c/2*t*t*t + b;
                        return c/2*((t-=2)*t*t + 2) + b;
                    };
                    break;
            }
            break;
        case 3:             // PBTweenFunctionQuart
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return c*(t/=d)*t*t*t + b; };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ return -c * ((t=t/d-1)*t*t*t - 1) + b; };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
                        return -c/2 * ((t-=2)*t*t*t - 2) + b;
                    };
                    break;
            }
            break;
        case 4:             // PBTweenFunctionQuint
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return c*(t/=d)*t*t*t*t + b; };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ return c*((t=t/d-1)*t*t*t*t + 1) + b; };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
                        return c/2*((t-=2)*t*t*t*t + 2) + b;
                    };
                    break;
            }
            break;
        case 5:             // PBTweenFunctionSine
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return -c * cos(t/d * (M_PI/2)) + c + b; };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ return c * sin(t/d * (M_PI/2)) + b; };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){ return -c/2 * (cos(M_PI*t/d) - 1) + b; };
                    break;
            }
            break;
        case 6:             // PBTweenFunctionExpo
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){
                        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
                    };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){
                        return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
                    };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if (t==0) return b;
                        if (t==d) return b+c;
                        if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
                        return c/2 * (-pow(2, -10 * --t) + 2) + b;
                    };
                    break;
            }
            break;
        case 7:             // PBTweenFunctionCirc
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return -c * (sqrt(1 - (t/=d)*t) - 1) + b; };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ return c * sqrt(1 - (t=t/d-1)*t) + b; };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
                        return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
                    };
                    break;
            }
            break;
        case 8:             // PBTweenFunctionElastic
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){
                        double a = 0.0;    // amplitude (optional) <振幅の大きさ>
                        double p = 0.0;    // period (optional) <値が大きいほど反発を吸収する>
                        double s = 0.0;
                        
                        if (t==0) return b;
                        if ((t/=d)==1) return b+c;
                        if (!p) p=d*.3;
                        if (a < fabs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
                    };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){
                        double a = 0.0;
                        double p = 0.0;
                        double s = 0.0;
                        
                        if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
                        if (a < fabs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
                    };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        double a = 0.0;
                        double p = 0.0;
                        double s = 0.0;
                        
                        if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
                        if (a < fabs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
                        return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
                    };
                    break;
            }
            break;
        case 9:             // PBTweenFunctionBack
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){
                        double s = 1.70158;     // overshoot <始点／終点を超える量> 1.70158 = 10%(Default)
                        return c*(t/=d)*t*((s+1)*t - s) + b;
                    };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){
                        double s = 1.70158;
                        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
                    };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        double s = 1.70158;
                        if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
                        return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
                    };
                    break;
            }
            break;
        case 10:            // PBTweenFunctionBounce
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d){ return PBEaseInBounce(t, b, c, d); };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d){ 
                        return PBEaseOutBounce(t, b, c, d); };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d){
                        if (t < d/2) return PBEaseInBounce(t*2, 0, c, d) * .5 + b;
                        else return PBEaseOutBounce(t*2-d, 0, c, d) * .5 + c*.5 + b;
                    };
                    break;
            }
            break;
        default:
            break;
    }
    return resultBlock;
}

/*
 dt, currentTime calcuration. http://www.kuma-de.com/blog/2010-07-02/2199
 */

NSArray *TweenedValues(PBTweenFunction function, double startValue, double endValue, double duration) {
    
    __weak tweenCalcBlock_t block = tweenCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration);
		[values addObject:[NSNumber numberWithDouble:value]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *TweenedCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration) {
    
    __weak tweenCalcBlock_t block = tweenCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endPoint.x - startPoint.x;
    double distanceY = endPoint.y - startPoint.y;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startPoint.x, distanceX, duration);
        CGFloat y = block(currentTime, startPoint.y, distanceY, duration);
		[values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *TweenedCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration) {
    
    __weak tweenCalcBlock_t block = tweenCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceWidth = endSize.width - startSize.width;
    double distanceHeight = endSize.height - startSize.height;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat width = block(currentTime, startSize.width, distanceWidth, duration);
        CGFloat height = block(currentTime, startSize.height, distanceHeight, duration);
		[values addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *TweenedCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration) {
    
    __weak tweenCalcBlock_t block = tweenCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endRect.origin.x - startRect.origin.x;
    double distanceY = endRect.origin.y - startRect.origin.y;
    double distanceWidth = endRect.size.width - startRect.size.width;
    double distanceHeight = endRect.size.height - startRect.size.height;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startRect.origin.x, distanceX, duration);
        CGFloat y = block(currentTime, startRect.origin.y, distanceY, duration);
        CGFloat width = block(currentTime, startRect.size.width, distanceWidth, duration);
        CGFloat height = block(currentTime, startRect.size.height, distanceHeight, duration);
		[values addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, height)]];
	}
    //    Block_release(block);
    
	return values;
}


NSArray *TweenedRadianValues(PBTweenFunction function, double startValue, double endValue, double duration) {
    
    __weak tweenCalcBlock_t block = tweenCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration);
		[values addObject:radiansToNumber(value)];
	}
    //    Block_release(block);
    
	return values;
}



CAKeyframeAnimation *PBTweenAnimationTypeOpacity(CGFloat startOpacity, CGFloat endOpacity, 
                                                 CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    anim.values = TweenedValues(function, startOpacity, endOpacity, duration);
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypeScale(CGFloat startScale, CGFloat endScale, 
                                               CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.values = TweenedValues(function, startScale, endScale, duration);
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypePosition(CGPoint startPosition, CGPoint endPosition, 
                                                  CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    anim.values = TweenedCGPointValues(function, startPosition, endPosition, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypeSize(CGSize startSize, CGSize endSize, 
                                              CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    anim.values = TweenedCGSizeValues(function, startSize, endSize, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationType2DRotate(double startDegrees, double endDegrees, 
                                                  CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.values = TweenedRadianValues(function, startDegrees, endDegrees, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}
CAKeyframeAnimation *PBTweenAnimationType3DRotate(double startDegrees, double endDegrees, 
                                                  CFTimeInterval duration, PBTweenFunction function, BOOL isVertical) {
    
    NSString *keyPath = (isVertical) ? @"transform.rotation.x" : @"transform.rotation.y";
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    anim.values = TweenedRadianValues(function, startDegrees, endDegrees, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithLayer(CALayer *animLayer, CGFloat zDistance,
                                                           double startDegrees, double endDegrees, CFTimeInterval duration, 
                                                           PBTweenFunction function, BOOL isVertical) {
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = 1.f / -(1000.f * zDistance);
    animLayer.transform = perspective;
    
    NSString *keyPath = (isVertical) ? @"transform.rotation.x" : @"transform.rotation.y";
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    anim.values = TweenedRadianValues(function, startDegrees, endDegrees, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAAnimation *PBTweenAnimationTypeFrame(CGRect startFrame, CGRect endFrame, 
                                       CFTimeInterval duration, PBTweenFunction function) {
    
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation  animationWithKeyPath:@"position"];
    positionAnim.values = TweenedCGPointValues(function, CGRectGetCenter(startFrame), CGRectGetCenter(endFrame), duration);
    
    CAKeyframeAnimation *sizeAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    sizeAnim.values = TweenedCGRectValues(function, startFrame, endFrame, duration);
    
    CAAnimationGroup *anim = [CAAnimationGroup animation];
    anim.animations = [NSArray arrayWithObjects:positionAnim, sizeAnim, nil];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}


#pragma mark - PBTweenFunctionElastic options

typedef double (^elasticCalcBlock_t)(double t, double b, double c, double d, double a, double p);

// a:amplitude(optional) <振幅の大きさ> p:period(optional) <値が大きいほど反発を吸収する>
elasticCalcBlock_t elasticCalcBlock(PBTweenFunction function);
elasticCalcBlock_t elasticCalcBlock(PBTweenFunction function) {
    
    int tweenType = function / 10;
    int easeType = function % 10;
    
    __weak elasticCalcBlock_t resultBlock = nil;
    switch (tweenType) {
        case 8:             // PBTweenFunctionElastic
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d, double a, double p){
                        double s = 0.0;
                        
                        if (t==0) return b;
                        if ((t/=d)==1) return b+c;
                        if (!p) p=d*.3;
                        if (a < abs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
                    };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d, double a, double p){
                        double s = 0.0;
                        
                        if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
                        if (a < abs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
                    };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d, double a, double p){
                        double s = 0.0;
                        
                        if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
                        if (a < abs(c)) { a=c; s=p/4; }
                        else s = p/(2*M_PI) * asin (c/a);
                        if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
                        return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
                    };
                    break;
            }
            break;
        default:
            break;
    }
    return resultBlock;
}

NSArray *ElasticValues(PBTweenFunction function, double startValue, double endValue, double duration, double amplitude, double period) {
    
    __weak elasticCalcBlock_t block = elasticCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration, amplitude, period);
		[values addObject:[NSNumber numberWithDouble:value]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *ElasticCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration, double amplitude, double period) {
    
    __weak elasticCalcBlock_t block = elasticCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endPoint.x - startPoint.x;
    double distanceY = endPoint.y - startPoint.y;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startPoint.x, distanceX, duration, amplitude, period);
        CGFloat y = block(currentTime, startPoint.y, distanceY, duration, amplitude, period);
		[values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *ElasticCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration, double amplitude, double period) {
    
    __weak elasticCalcBlock_t block = elasticCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceWidth = endSize.width - startSize.width;
    double distanceHeight = endSize.height - startSize.height;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat width = block(currentTime, startSize.width, distanceWidth, duration, amplitude, period);
        CGFloat height = block(currentTime, startSize.height, distanceHeight, duration, amplitude, period);
		[values addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *ElasticCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration, double amplitude, double period) {
    
    __weak elasticCalcBlock_t block = elasticCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endRect.origin.x - startRect.origin.x;
    double distanceY = endRect.origin.y - startRect.origin.y;
    double distanceWidth = endRect.size.width - startRect.size.width;
    double distanceHeight = endRect.size.height - startRect.size.height;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startRect.origin.x, distanceX, duration, amplitude, period);
        CGFloat y = block(currentTime, startRect.origin.y, distanceY, duration, amplitude, period);
        CGFloat width = block(currentTime, startRect.size.width, distanceWidth, duration, amplitude, period);
        CGFloat height = block(currentTime, startRect.size.height, distanceHeight, duration, amplitude, period);
		[values addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, height)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *ElasticRadianValues(PBTweenFunction function, double startValue, double endValue, double duration, double amplitude, double period) {
    
    __weak elasticCalcBlock_t block = elasticCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration, amplitude, period);
		[values addObject:radiansToNumber(value)];
	}
    //    Block_release(block);
    
	return values;
}


#pragma mark - PBTweenFunctionBack options

typedef double (^backCalcBlock_t)(double t, double b, double c, double d, double s);

// s:overshoot <始点／終点を超える量> 1.70158 = 10%(Default)
backCalcBlock_t backCalcBlock(PBTweenFunction function);
backCalcBlock_t backCalcBlock(PBTweenFunction function) {
    
    int tweenType = function / 10;
    int easeType = function % 10;
    
    __weak backCalcBlock_t resultBlock = nil;
    switch (tweenType) {
        case 9:             // PBTweenFunctionBack
            switch (easeType) {
                case 0:
                    resultBlock = ^(double t, double b, double c, double d, double s){
                        return c*(t/=d)*t*((s+1)*t - s) + b;
                    };
                    break;
                case 1:
                    resultBlock = ^(double t, double b, double c, double d, double s){
                        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
                    };
                    break;
                case 2:
                    resultBlock = ^(double t, double b, double c, double d, double s){
                        if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
                        return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
                    };
                    break;
            }
            break;
        default:
            break;
    }
    return resultBlock;
}

NSArray *BackValues(PBTweenFunction function, double startValue, double endValue, double duration, double overshoot) {
    
    __weak backCalcBlock_t block = backCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
    if (overshoot == 0.0)
        overshoot = 1.70158;
	
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration, overshoot);
		[values addObject:[NSNumber numberWithDouble:value]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *BackCGPointValues(PBTweenFunction function, CGPoint startPoint, CGPoint endPoint, double duration, double overshoot) {
    
    __weak backCalcBlock_t block = backCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endPoint.x - startPoint.x;
    double distanceY = endPoint.y - startPoint.y;
	if (overshoot == 0.0)
        overshoot = 1.70158;
    
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startPoint.x, distanceX, duration, overshoot);
        CGFloat y = block(currentTime, startPoint.y, distanceY, duration, overshoot);
		[values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *BackCGSizeValues(PBTweenFunction function, CGSize startSize, CGSize endSize, double duration, double overshoot) {
    
    __weak backCalcBlock_t block = backCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceWidth = endSize.width - startSize.width;
    double distanceHeight = endSize.height - startSize.height;
	if (overshoot == 0.0)
        overshoot = 1.70158;
    
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat width = block(currentTime, startSize.width, distanceWidth, duration, overshoot);
        CGFloat height = block(currentTime, startSize.height, distanceHeight, duration, overshoot);
		[values addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *BackCGRectValues(PBTweenFunction function, CGRect startRect, CGRect endRect, double duration, double overshoot) {
    
    __weak backCalcBlock_t block = backCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distanceX = endRect.origin.x - startRect.origin.x;
    double distanceY = endRect.origin.y - startRect.origin.y;
    double distanceWidth = endRect.size.width - startRect.size.width;
    double distanceHeight = endRect.size.height - startRect.size.height;
	if (overshoot == 0.0)
        overshoot = 1.70158;
    
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		CGFloat x = block(currentTime, startRect.origin.x, distanceX, duration, overshoot);
        CGFloat y = block(currentTime, startRect.origin.y, distanceY, duration, overshoot);
        CGFloat width = block(currentTime, startRect.size.width, distanceWidth, duration, overshoot);
        CGFloat height = block(currentTime, startRect.size.height, distanceHeight, duration, overshoot);
		[values addObject:[NSValue valueWithCGRect:CGRectMake(x, y, width, height)]];
	}
    //    Block_release(block);
    
	return values;
}
NSArray *BackRadianValues(PBTweenFunction function, double startValue, double endValue, double duration, double overshoot) {
    
    __weak backCalcBlock_t block = backCalcBlock(function);
    
    NSUInteger count = IPHONE_FRAME_RATE * duration;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:count];
    double dt = 1.0f / count;
    double distance = endValue - startValue;
	if (overshoot == 0.0)
        overshoot = 1.70158;
    
	for (int i = 0; i <= count; i++) {
        double currentTime = (dt * i) * duration;
		double value = block(currentTime, startValue, distance, duration, overshoot);
		[values addObject:radiansToNumber(value)];
	}
    //    Block_release(block);
    
	return values;
}



CAKeyframeAnimation *PBTweenAnimationTypeOpacityWithOption(CGFloat startOpacity, CGFloat endOpacity, 
                                                           CFTimeInterval duration, PBTweenFunction function, 
                                                           double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationTypeOpacity(startOpacity, endOpacity, duration, function);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackValues(function, startOpacity, endOpacity, duration, overshoot);
    else    // Elastic
        anim.values = ElasticValues(function, startOpacity, endOpacity, duration, amplitude, period);
    
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypeScaleWithOption(CGFloat startScale, CGFloat endScale, 
                                                         CFTimeInterval duration, PBTweenFunction function, 
                                                         double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationTypeScale(startScale, endScale, duration, function);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackValues(function, startScale, endScale, duration, overshoot);
    else    // Elastic
        anim.values = ElasticValues(function, startScale, endScale, duration, amplitude, period);
    
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypePositionWithOption(CGPoint startPosition, CGPoint endPosition, 
                                                            CFTimeInterval duration, PBTweenFunction function, 
                                                            double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationTypePosition(startPosition, endPosition, duration, function);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackCGPointValues(function, startPosition, endPosition, duration, overshoot);
    else    // Elastic
        anim.values = ElasticCGPointValues(function, startPosition, endPosition, duration, amplitude, period);
    
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationTypeSizeWithOption(CGSize startSize, CGSize endSize, 
                                                        CFTimeInterval duration, PBTweenFunction function, 
                                                        double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationTypeSize(startSize, endSize, duration, function);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size"];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackCGSizeValues(function, startSize, endSize, duration, overshoot);
    else    // Elastic
        anim.values = ElasticCGSizeValues(function, startSize, endSize, duration, amplitude, period);
    
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAKeyframeAnimation *PBTweenAnimationType2DRotateWithOption(double startDegrees, double endDegrees, 
                                                            CFTimeInterval duration, PBTweenFunction function, 
                                                            double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationType2DRotate(startDegrees, endDegrees, duration, function);
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.values = TweenedRadianValues(function, startDegrees, endDegrees, duration);
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithOption(double startDegrees, double endDegrees, 
                                                            CFTimeInterval duration, PBTweenFunction function, BOOL isVertical, 
                                                            double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationType3DRotate(startDegrees, endDegrees, duration, function, isVertical);
    
    NSString *keyPath = (isVertical) ? @"transform.rotation.x" : @"transform.rotation.y";
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackRadianValues(function, startDegrees, endDegrees, duration, overshoot);
    else    // Elastic
        anim.values = ElasticRadianValues(function, startDegrees, endDegrees, duration, amplitude, period);
    
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}
CAKeyframeAnimation *PBTweenAnimationType3DRotateWithLayerWithOption(CALayer *animLayer, CGFloat zDistance,
                                                                     double startDegrees, double endDegrees, CFTimeInterval duration, 
                                                                     PBTweenFunction function, BOOL isVertical, 
                                                                     double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationType3DRotateWithLayer(animLayer, zDistance, startDegrees, endDegrees, duration, function, isVertical);
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = 1.f / -(1000.f * zDistance);
    animLayer.transform = perspective;
    
    NSString *keyPath = (isVertical) ? @"transform.rotation.x" : @"transform.rotation.y";
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    
    if (function >= PBTweenFunctionBackEaseIn)
        anim.values = BackRadianValues(function, startDegrees, endDegrees, duration, overshoot);
    else    // Elastic
        anim.values = ElasticRadianValues(function, startDegrees, endDegrees, duration, amplitude, period);
    
    anim.duration = duration;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    return anim;
}

CAAnimation *PBTweenAnimationTypeFrameWithOption(CGRect startFrame, CGRect endFrame, 
                                                 CFTimeInterval duration, PBTweenFunction function, 
                                                 double amplitude, double period, double overshoot) {
    
    if (function < PBTweenFunctionElasticEaseIn || function > PBTweenFunctionBackEaseInOut)
        return PBTweenAnimationTypeFrame(startFrame, endFrame, duration, function);
    
    
    CAKeyframeAnimation *positionAnim = [CAKeyframeAnimation  animationWithKeyPath:@"position"];
    if (function >= PBTweenFunctionBackEaseIn)
        positionAnim.values = BackCGPointValues(function, CGRectGetCenter(startFrame), CGRectGetCenter(endFrame), duration, overshoot);
    else    // Elastic
        positionAnim.values = ElasticCGPointValues(function, CGRectGetCenter(startFrame), CGRectGetCenter(endFrame), duration, amplitude, period);
    
    CAKeyframeAnimation *sizeAnim = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    if (function >= PBTweenFunctionBackEaseIn)
        sizeAnim.values = BackCGRectValues(function, startFrame, endFrame, duration, overshoot);
    else    // Elastic
        sizeAnim.values = ElasticCGRectValues(function, startFrame, endFrame, duration, amplitude, period);
    
    CAAnimationGroup *anim = [CAAnimationGroup animation];
    anim.animations = [NSArray arrayWithObjects:positionAnim, sizeAnim, nil];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
	anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

