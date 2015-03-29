#import "TransmitterView.h"
#import <QuartzCore/QuartzCore.h>
#import "TransmitterStickView.h"

@implementation TransmitterView

@synthesize imageView, leftStick, rightStick;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = [NSImage imageNamed:@"Radio_Blank"];
    [imageView setWantsLayer:YES];
    [self addSubview:imageView];
    
    self.leftStick = [self createStickView];
    leftStick.layer.position = CGPointMake([self leftStickMidX], [self stickMidY]);
    
    self.rightStick = [self createStickView];
    rightStick.layer.position = CGPointMake([self rightStickMidX], [self stickMidY]);
}

- (TransmitterStickView *)createStickView {
    TransmitterStickView *stickView = [[TransmitterStickView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [stickView setWantsLayer:YES];
    [self addSubview:stickView];
    [stickView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    return stickView;
}


#pragma mark - General stick measurements

- (float)stickMidY {
    return (float) (self.frame.size.height / 2.35);
}

- (float)stickMaxY {
    return [self stickMidY] + [self stickMoveY];
}

- (float)stickMinY {
    return [self stickMidY] - [self stickMoveY];
}

- (float)stickMoveX {
    return (float) (self.frame.size.width / 10.18);
}

- (float)stickMoveY {
    return (float) (self.frame.size.height / 9.95);
}

#pragma mark - Left Stick - Relative Measurements

- (float)leftStickMidX {
    return (float) (self.frame.size.width / 4.139);
}

- (float)leftStickMaxX {
    return [self leftStickMidX] + [self stickMoveX];
}

- (float)leftStickMinX {
    return [self leftStickMidX] - [self stickMoveX];
}

#pragma mark - Right Stick - Relative Measurements

- (float)rightStickMidX {
    return (float) (self.frame.size.width / 1.35);
}

- (float)rightStickMaxX {
    return [self rightStickMidX] + [self stickMoveX];
}

- (float)rightStickMinX {
    return [self rightStickMidX] - [self stickMoveX];
}

- (CABasicAnimation*)stickAnimation {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:1.0];
    [animation setRepeatCount:INT_MAX];
    [animation setAutoreverses:YES];
    return animation;
}

- (void)animateThrottle {
    [self removeAnimations];
    
    CABasicAnimation* animation = [self stickAnimation];
    [animation setFromValue:[NSValue valueWithPoint:CGPointMake([self leftStickMidX], [self stickMinY])]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake([self leftStickMidX], [self stickMaxY])]];
    [leftStick.layer addAnimation:animation forKey:@"throttleDemo"];
}

- (void)animateYaw {
    [self removeAnimations];
    
    CABasicAnimation* animation = [self stickAnimation];
    [animation setFromValue:[NSValue valueWithPoint:CGPointMake([self leftStickMinX], [self stickMidY])]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake([self leftStickMaxX], [self stickMidY])]];
    [leftStick.layer addAnimation:animation forKey:@"yawDemo"];
}

- (void)animatePitch {
    [self removeAnimations];
    
    CABasicAnimation* animation = [self stickAnimation];
    [animation setFromValue:[NSValue valueWithPoint:CGPointMake([self rightStickMidX], [self stickMinY])]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake([self rightStickMidX], [self stickMaxY])]];
    [rightStick.layer addAnimation:animation forKey:@"pitchDemo"];
}

- (void)animateRoll {
    [self removeAnimations];
    
    CABasicAnimation* animation = [self stickAnimation];
    [animation setFromValue:[NSValue valueWithPoint:CGPointMake([self rightStickMinX], [self stickMidY])]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake([self rightStickMaxX], [self stickMidY])]];
    [rightStick.layer addAnimation:animation forKey:@"rollDemo"];
}

- (void)removeAnimations {
    [leftStick.layer removeAllAnimations];
    [rightStick.layer removeAllAnimations];
}

- (void)updateThrottle:(NSInteger)throttle yaw:(NSInteger)yaw pitch:(NSInteger)pitch roll:(NSInteger)roll {
    leftStick.layer.position = CGPointMake([self leftStickMinX] + (yaw/12.5) - 5, [self stickMinY] + (throttle/12.5) - 5);
    rightStick.layer.position = CGPointMake([self rightStickMinX] + (roll/12.5) - 5, [self stickMinY] + (pitch/12.5) - 5);
}

@end
