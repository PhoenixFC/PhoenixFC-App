#import <Cocoa/Cocoa.h>
#import "TransmitterStickView.h"

@interface TransmitterView : NSView

@property (retain) NSImageView *imageView;
@property (retain) TransmitterStickView *leftStick;
@property (retain) TransmitterStickView *rightStick;

- (void)animateThrottle;
- (void)animateYaw;
- (void)animatePitch;
- (void)animateRoll;

- (void)removeAnimations;

- (void)updateThrottle:(NSInteger)throttle yaw:(NSInteger)yaw pitch:(NSInteger)pitch roll:(NSInteger)roll;

@end
