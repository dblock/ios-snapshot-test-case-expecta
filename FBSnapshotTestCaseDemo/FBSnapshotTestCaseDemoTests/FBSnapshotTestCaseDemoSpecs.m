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
#include "EXPMatchers+FBSnapshotTest.h"
#include "FBExampleView.h"

SpecBegin(FBExampleView)

beforeAll(^{
    NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%s", FB_REFERENCE_IMAGE_DIR];
    [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory:referenceImagesDirectory];
});

it(@"matches view", ^{
    FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    expect(view).to.recordSnapshot(@"FBExampleView");
    expect(view).to.haveValidSnapshot(@"FBExampleView");
});

it(@"doesn't match a view", ^{
    FBExampleView *view = [[FBExampleView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    expect(view).toNot.haveValidSnapshot(@"FBExampleViewDoesNotExist");
});

SpecEnd

