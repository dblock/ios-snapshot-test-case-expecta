//
//  FBSnapshotTestCaseDemoSpecs.m
//  FBSnapshotTestCaseDemo
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#define EXP_SHORTHAND
#include <Specta/Specta.h>
#include <Expecta/Expecta.h>
#include <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>

#include "FBExampleView.h"
#import "FBViewController.h"
#import "EXPExpect+Test.h"

#define test_expect(a) [expect(a) test]
#define assertPass(expr) \
XCTAssertNoThrow((expr))


SpecBegin(FBExampleView)

__block CGRect frame;

beforeAll(^{
    frame = CGRectMake(0, 0, 64, 64);
});

describe(@"manual matching", ^{

    it(@"matches view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:frame];
        expect(view).to.haveValidSnapshotNamed(@"FBExampleView");
    });

    it(@"doesn't match a view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:frame];
        expect(view).toNot.haveValidSnapshotNamed(@"FBExampleViewDoesNotExist");
    });

});

describe(@"test name derived matching", ^{

    it(@"matches view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:frame];
        expect(view).to.haveValidSnapshot();
    });

    it(@"doesn't match a view", ^{
        FBExampleView *view = [[FBExampleView alloc] initWithFrame:frame];
        expect(view).toNot.haveValidSnapshot();
    });

});


describe(@"supports view controller matching", ^{
    __block FBViewController *controller;

    before(^{
        controller = [[FBViewController alloc] init];
        controller.view.frame = frame;
    });

    it(@"matches view controller named", ^{

        XCTAssertThrows( test_expect(controller).to.recordSnapshotNamed(@"view controller"), @"Recording did not fail correctly");

        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
    });


    it(@"matches view controller unnamed", ^{

        XCTAssertThrows( test_expect(controller).to.recordSnapshot(), @"Recording did not fail correctly");

        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
    });


    it(@"matches view controller named", ^{

        XCTAssertThrows( test_expect(controller).to.haveValidSnapshotNamed(@"view controller 2"), @"Recording did not fail correctly");

        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
    });

    it(@"matches view controller named", ^{

        XCTAssertThrows( test_expect(controller).to.haveValidSnapshot(), @"Recording did not fail correctly");

        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
    });

});


SpecEnd

