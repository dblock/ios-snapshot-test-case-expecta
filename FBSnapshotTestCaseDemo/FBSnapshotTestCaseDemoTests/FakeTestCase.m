// Extracted from https://github.com/specta/expecta

#import "FakeTestCase.h"

@implementation FakeTestCase

- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected {
    [NSException raise:description format:nil];
}

@end