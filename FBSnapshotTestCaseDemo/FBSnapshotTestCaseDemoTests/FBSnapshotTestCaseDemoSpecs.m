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
#import <FBSnapshotTestCase/FBSnapshotTestCasePlatform.h>

#include "FBExampleView.h"
#import "FBViewController.h"

#define test_expect(a) [expect(a) test]
#define assertPass(expr) \
XCTAssertNoThrow((expr))

#import "EXPExpect+Test.h"

#import <malloc/malloc.h>
#import <objc/runtime.h>

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
                expect(imageName).to.contain(@"view_1");
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
                expect(imageName).to.contain(@"view_controller_1");
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
  
  describe(@"device agnostic", ^{
    
    __block FBViewController *controller;
    
    before(^{
      controller = [[FBRedViewController alloc] init];
      controller.view.frame = frame;
      [Expecta setDeviceAgnostic:TRUE];
    });
    
    after(^{
      [Expecta setDeviceAgnostic:FALSE];
    });
    
    describe(@"recording", ^{
      
      it(@"named", ^{
        expect(controller).toNot.recordSnapshotNamed(@"view controller 1");
        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
        NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
        NSString *expectedImageName = FBFileNameIncludeNormalizedFileNameFromOption(@"view_controller_1", 0);
        expect(imageName).to.contain(expectedImageName);
      });
      
      it(@"unnamed", ^{
        expect(controller).toNot.recordSnapshot();
        expect(controller.viewWillAppearCalled).to.beTruthy();
        expect(controller.viewDidAppearCalled).to.beTruthy();
        NSString *imageName = [[fileManager contentsOfDirectoryAtPath:imagesDirectory error:nil] firstObject];
        NSString *expectedImageName = FBFileNameIncludeNormalizedFileNameFromOption(@"snapshots_device_agnostic_recording_unnamed", 0);
        expect(imageName).to.contain(expectedImageName);
      });
      
    });
    
    describe(@"unnamed", ^{
      
      describe(@"named", ^{
        
        it(@"matches view controller", ^{
          expect(controller).toNot.recordSnapshotNamed(@"view controller 2");
          
          FBViewController *newVC = [[FBRedViewController alloc] init];
          newVC.view.frame = frame;
          expect(newVC).to.haveValidSnapshotNamed(@"view controller 2");
          expect(newVC.viewWillAppearCalled).to.beTruthy();
          expect(newVC.viewDidAppearCalled).to.beTruthy();
        });
        
      });
      
      it(@"matches view controller", ^{
        expect(controller).toNot.recordSnapshot();
        
        FBViewController *newVC = [[FBRedViewController alloc] init];
        newVC.view.frame = frame;
        expect(newVC).to.haveValidSnapshot();
        expect(newVC.viewWillAppearCalled).to.beTruthy();
        expect(newVC.viewDidAppearCalled).to.beTruthy();
      });
      
    });
    
  });

    describe(@"with tolerance", ^{
        __block FBExampleView *view;

        before(^{
            view = [[FBRedView alloc] initWithFrame:frame];
            expect(view).toNot.recordSnapshot();

            CGAffineTransform scale = CGAffineTransformMakeScale(0.5, 0.5);
            CGRect rect = CGRectApplyAffineTransform(frame, scale);
            FBBlueView *blueView = [[FBBlueView alloc] initWithFrame:rect];
            [view addSubview:blueView];
        });

        it(@"matches if tolerance is enough", ^{
            expect(view).to.haveValidSnapshotWithTolerance(0.25);
        });

        it(@"does not match if tolerance is not enough", ^{
            expect(view).toNot.haveValidSnapshotWithTolerance(0.24);
        });
    });
    
    it(@"matches view with 256 bytes aligned pointer", ^{
        Class viewClass = [UIView class];
        size_t viewInstanceSize = class_getInstanceSize(viewClass);
        void *ptr = calloc(255 + viewInstanceSize, 1);
        void *alignedPtr = nil;
        
        for (int i = 0; i < 256; ++i) {
            signed char ptrVal = (signed char)(ptr + i);
            
            if (ptrVal == 0) {
                alignedPtr = ptr + i;
            }
        }
        
        UIView *view;
        
        @autoreleasepool {
            if (alignedPtr) {
                id result = (__bridge_transfer id)alignedPtr;
                object_setClass(result, viewClass);
                
                view = [result initWithFrame:frame];
                CFRetain((__bridge CFTypeRef)view); // prevent ARC from deallocation
            }
            
            expect(view).toNot.recordSnapshot();
            expect(view).to.haveValidSnapshot();
            
//            [view dealloc]; // should be called manually
        }
        
        free(ptr);
    });
});

SpecEnd

