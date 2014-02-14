ios-snapshot-test-case-expecta
==============================

[Expecta](https://github.com/specta/expecta) matchers for [ios-snapshot-test-case](https://github.com/facebook/ios-snapshot-test-case).

[![Build Status](https://travis-ci.org/dblock/ios-snapshot-test-case-expecta.png)](https://travis-ci.org/dblock/ios-snapshot-test-case-expecta)

### Usage

Add `FBSnapshotTestCase` and `EXPMatchers+FBSnapshotTest` to your Podfile.

``` ruby
pod 'FBSnapshotTestCase', :git => 'https://github.com/dblock/ios-snapshot-test-case', :branch => 'fb-snapshot-test-controller'
pod 'EXPMatchers+FBSnapshotTest', :git => 'https://github.com/dblock/ios-snapshot-test-case-expecta'
```

This requires a fork and the `fb-snapshot-test-recorder` branch, until [ios-snapshot-test-case#13](https://github.com/facebook/ios-snapshot-test-case/pull/13) is merged.

### App setup

Specify the location of reference images with `setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);`. This only needs to be called once. You may place it in the first test suite, which are usually executed in alphabetical order.

Use `expect(view).to.recordSnapshotNamed(@"unique snapshot name")` to record a snapshot and `expect(view).to.haveValidSnapshotNamed(@"unique snapshot name")` to check it.

If you project was compiled with Specta included, you have two extra methods that use the spec hierarchy to generate the snapshot name for you: `recordSnapshot()` and `haveValidSnapshot()`. You should only call these once per `it()` block.

``` Objective-C
#define EXP_SHORTHAND
#include <Specta/Specta.h>
#include <Expecta/Expecta.h>
#include <EXPMatchers+FBSnapshotTest/EXPMatchers+FBSnapshotTest.h>
#include "FBExampleView.h"

SpecBegin(FBExampleView)

setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);

describe(@"manual matching", ^{

    it(@"matches view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        expect(view).to.recordSnapshotNamed(@"FBExampleView");
        expect(view).to.haveValidSnapshotNamed(@"FBExampleView");
    });

    it(@"doesn't match a view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        expect(view).toNot.haveValidSnapshotNamed(@"FBExampleViewDoesNotExist");
    });

});

describe(@"test name derived matching", ^{

    it(@"matches view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        expect(view).to.recordSnapshot();
        expect(view).to.haveValidSnapshot();
    });

    it(@"doesn't match a view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        expect(view).toNot.haveValidSnapshot();
    });

});

SpecEnd
```

### Example

A complete project can be found in [FBSnapshotTestCaseDemo](FBSnapshotTestCaseDemo).

Notably, take a look at [FBSnapshotTestCaseDemoSpecs.m](FBSnapshotTestCaseDemo/FBSnapshotTestCaseDemoTests/FBSnapshotTestCaseDemoSpecs.m) for a complete example, which is an expanded Specta version version of [FBSnapshotTestCaseDemoTests.m](https://github.com/facebook/ios-snapshot-test-case/blob/master/FBSnapshotTestCaseDemo/FBSnapshotTestCaseDemoTests/FBSnapshotTestCaseDemoTests.m).

### License

MIT, see [LICENSE](LICENSE.md)
