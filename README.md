ios-snapshot-test-case-expecta
==============================

### What?

[Expecta](https://github.com/specta/expecta) matchers for [ios-snapshot-test-case](https://github.com/facebook/ios-snapshot-test-case).

### Usage

Add `FBSnapshotTestCase` and `EXPMatchers+FBSnapshotTest` to your Podfile.

``` ruby
pod 'FBSnapshotTestCase', :git => 'https://github.com/dblock/ios-snapshot-test-case', :branch => 'fb-snapshot-test-recorder'
pod 'EXPMatchers+FBSnapshotTest', :git => 'https://github.com/dblock/ios-snapshot-test-case-expecta'
pod 'Specta', '~> 0.2.1'
pod 'Expecta', '~> 0.2.3'
```

This requires a fork and the `fb-snapshot-test-recorder` branch, until [ios-snapshot-test-case#8](https://github.com/facebook/ios-snapshot-test-case/pull/8) is merged.

Use `expect(view).to.recordSnapshot(@"unique snapshot name")` to record a snapshot and `expect(view).to.haveValidSnapshot(@"unique snapshot name")` to check it.


``` ObjectiveC
#define EXP_SHORTHAND
#include <Specta/Specta.h>
#include <Expecta/Expecta.h>
#include "EXPMatchers+FBSnapshotTest.h"
#include "FBExampleView.h"

SpecBegin(FBExampleView)

beforeAll(^{
    NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%s", FB_REFERENCE_IMAGE_DIR];
    [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory:referenceImagesDirectory];
});

it(@"matches view", ^{
    FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    // expect(view).to.recordSnapshot(@"FBExampleView");
    expect(view).to.haveValidSnapshot(@"FBExampleView");
});

SpecEnd
```

### Example

A complete project can be found in [FBSnapshotTestCaseDemo](FBSnapshotTestCaseDemo).

Notably, take a look at [FBSnapshotTestCaseDemoSpecs.m](FBSnapshotTestCaseDemo/FBSnapshotTestCaseDemoTests/FBSnapshotTestCaseDemoSpecs.m) for a complete example, which is a Specta version version of [FBSnapshotTestCaseDemoTests.m](https://github.com/facebook/ios-snapshot-test-case/blob/master/FBSnapshotTestCaseDemo/FBSnapshotTestCaseDemoTests/FBSnapshotTestCaseDemoTests.m).

### License

MIT, see [LICENSE](LICENSE.md)
