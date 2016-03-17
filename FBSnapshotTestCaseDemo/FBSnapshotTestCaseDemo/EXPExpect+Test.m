#import "EXPExpect+Test.h"
#import "FakeTestCase.h"
#import <objc/runtime.h>


@implementation EXPExpect (Test)
- (EXPExpect *)test
{
    id testcase = [[FakeTestCase alloc] init];
    self.testCase = testcase;
    
    objc_setAssociatedObject(self, @selector(test), testcase, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

@end
