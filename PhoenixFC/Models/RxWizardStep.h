#import <Foundation/Foundation.h>

@interface RxWizardStep : NSObject

@property (retain) NSString *label;
@property (retain) NSString *transmitterImageName;
@property (assign) SEL animationSelector;

- (id)initWithLabel:(NSString *)aLabel imageName:(NSString *)imageName andSelector:(SEL)aSelector;

@end
