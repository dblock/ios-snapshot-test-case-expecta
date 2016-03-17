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

#define test_expect(a) [expect(a) test]
#define assertPass(expr) \
XCTAssertNoThrow((expr))

#import "EXPExpect+Test.h"

SpecBegin(FBExampleView)

__block CGRect frame = CGRectMake(0, 0, 64, 64);
__block NSFileManager *fileManager = [[NSFileManager alloc] init];
__block NSString *imagesDirectory = [NSString stringWithFormat:@"%s/%@", FB_REFERENCE_IMAGE_DIR, @"FBExampleViewSpec"];

describe(@"snapshots", ^{

    dispatch_block_t deleteSnapshots = ^{
        NSArray *files = [fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil];
        for (NSString *file in files) {
            NSString *fullPath = [imagesDirectory stringByAppendingPathComponent:file];
            [fileManager removeItemAtPath:fullPath error:nil];
        }
    };

    beforeEach(deleteSnapshots);
    afterAll(deleteSnapshots);

    describe(@"with a view", ^{
        __block FBExampleView *view;

        beforeEach(^{
            view = [[FBRedView alloc] initWithFrame:frame];
        });

        describe(@"recording", ^{
            it(@"named", ^{
                expect(view).toNot.recordSnapshotNamed(@"view 1"); // Using "toNot" because recording always causes the test to fail.
                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
                expect(imageName).to.contain(@"view 1");
            });

            it(@"unnamed", ^{
                expect(view).toNot.recordSnapshot();
                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
                expect(imageName).to.contain(@"snapshots_with_a_view_recording_unnamed");
            });
        });

        describe(@"matching", ^{
            describe(@"named", ^{
                it(@"matches view", ^{
                    expect(view).toNot.recordSnapshotNamed(@"view 2");
                    expect(view).to.haveValidSnapshotNamed(@"view 2");
                });

                it(@"doesn't match if file doesn't exist", ^{
                    expect(view).toNot.haveValidSnapshotNamed(@"nonexistent image");
                });

                it(@"doesn't match if files differ", ^{
                    expect(view).toNot.recordSnapshotNamed(@"view 3");
                    UIView *newView = [[FBBlueView alloc] initWithFrame:frame];
                    expect(newView).toNot.haveValidSnapshotNamed(@"view 3");
                });
            });

            describe(@"unnamed", ^{
                it(@"matches view", ^{
                    expect(view).toNot.recordSnapshot();
                    expect(view).to.haveValidSnapshot();
                });

                it(@"doesn't match if file doesn't exist", ^{
                    expect(view).toNot.haveValidSnapshot();
                });

                it(@"doesn't match if files differ", ^{
                    expect(view).toNot.recordSnapshot();
                    UIView *newView = [[FBBlueView alloc] initWithFrame:frame];
                    expect(newView).toNot.haveValidSnapshot();
                });
            });
        });
    });

    describe(@"with a view controller", ^{
        __block FBViewController *controller;

        before(^{
            controller = [[FBRedViewController alloc] init];
            controller.view.frame = frame;
        });


        describe(@"recording", ^{
            it(@"named", ^{
                expect(controller).toNot.recordSnapshotNamed(@"view controller 1");
                expect(controller.viewWillAppearCalled).to.beTruthy();
                expect(controller.viewDidAppearCalled).to.beTruthy();
                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
                expect(imageName).to.contain(@"view controller 1");
            });


            it(@"unnamed", ^{
                expect(controller).toNot.to.recordSnapshot();
                expect(controller.viewWillAppearCalled).to.beTruthy();
                expect(controller.viewDidAppearCalled).to.beTruthy();
                NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
                expect(imageName).to.contain(@"snapshots_with_a_view_controller_recording_unnamed");
            });
        });

        describe(@"matching", ^{

            describe(@"named", ^{
                it(@"matches view controller", ^{
                    expect(controller).toNot.recordSnapshotNamed(@"view controller 2");

                    FBViewController *newVC = [[FBRedViewController alloc] init];
                    newVC.view.frame = frame;
                    expect(newVC).to.haveValidSnapshotNamed(@"view controller 2");
                    expect(newVC.viewWillAppearCalled).to.beTruthy();
                    expect(newVC.viewDidAppearCalled).to.beTruthy();
                });

                it(@"doesn't match if file doesn't exist", ^{
                    expect(controller).toNot.haveValidSnapshotNamed(@"nonexistent image");
                    expect(controller.viewWillAppearCalled).to.beTruthy();
                    expect(controller.viewDidAppearCalled).to.beTruthy();
                });

                it(@"doesn't match if files differ", ^{
                    expect(controller).toNot.recordSnapshotNamed(@"view controller 3");

                    FBViewController *newVC = [[FBBlueViewController alloc] init];
                    newVC.view.frame = frame;
                    expect(newVC).toNot.haveValidSnapshotNamed(@"view controller 3");
                    expect(newVC.viewWillAppearCalled).to.beTruthy();
                    expect(newVC.viewDidAppearCalled).to.beTruthy();
                });
            });

            describe(@"unnamed", ^{
                it(@"matches view controller", ^{
                    expect(controller).toNot.recordSnapshot();

                    FBViewController *newVC = [[FBRedViewController alloc] init];
                    newVC.view.frame = frame;
                    expect(newVC).to.haveValidSnapshot();
                    expect(newVC.viewWillAppearCalled).to.beTruthy();
                    expect(newVC.viewDidAppearCalled).to.beTruthy();
                });

                it(@"doesn't match if file doesn't exist", ^{
                    expect(controller).toNot.haveValidSnapshot();
                    expect(controller.viewWillAppearCalled).to.beTruthy();
                    expect(controller.viewDidAppearCalled).to.beTruthy();
                });

                it(@"doesn't match if files differ", ^{
                    expect(controller).toNot.recordSnapshot();

                    FBViewController *newVC = [[FBBlueViewController alloc] init];
                    newVC.view.frame = frame;
                    expect(newVC).toNot.haveValidSnapshot();
                    expect(newVC.viewWillAppearCalled).to.beTruthy();
                    expect(newVC.viewDidAppearCalled).to.beTruthy();
                });
            });

        });

        it(@"Raises when a nil is passed in", ^{
            expect(^{
                [expect(nil) test].to.haveValidSnapshot() ;
            }).to.raise(@"Nil was passed into haveValidSnapshot. snapshots_with_a_view_controller_Raises_when_a_nil_is_passed_in");
        });
    });
});

SpecEnd

