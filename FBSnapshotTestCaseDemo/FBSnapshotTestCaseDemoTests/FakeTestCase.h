// Extracted from https://github.com/specta/expecta

@interface FakeTestCase : NSObject

- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected;
@end
