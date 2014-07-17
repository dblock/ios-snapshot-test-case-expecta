// Extracted from https://github.com/specta/expecta

#import "EXPExpect+Test.h"
#import "FakeTestCase.h"

static id testCase;

@implementation EXPExpect (Test)

- (EXPExpect *)test
{
    testCase = [FakeTestCase new];
    self.testCase = testCase;
    return self;
}

@end
