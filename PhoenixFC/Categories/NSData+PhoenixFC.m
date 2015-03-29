#import "NSData+PhoenixFC.h"

@implementation NSData (PhoenixFC)

- (NSInteger)getIntegerWithRange:(NSRange)range {
    // TODO: Is there a more efficient way to do this ?
    NSString *value = [[NSString alloc] initWithData:[self subdataWithRange:range] encoding:NSASCIIStringEncoding];
    return [value intValue];
}

@end
