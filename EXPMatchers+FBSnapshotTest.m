//
//  EXPMatchers+FBSnapshotTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "EXPMatchers+FBSnapshotTest.h"
#import "EXPMatcherHelpers.h"
#import "FBTestSnapshotController.h"
#import "FBSnapshotTestRecorder.h"

@implementation EXPExpect (FBSnapshotTest)
+(BOOL)compareSnapshotOfViewOrLayer:(id)viewOrLayer
                           snapshot:(NSString *)snapshot
                           testCase:(id)testCase
                             record:(BOOL)record
{
    FBTestSnapshotController * snapshotController = [[FBTestSnapshotController alloc] initWithTestClass:[testCase class]];
    FBSnapshotTestRecorder * recorder = [[FBSnapshotTestRecorder alloc] initWithController:snapshotController];
    recorder.selector = NSSelectorFromString(snapshot);
    recorder.recordMode = record;
    NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%s", FB_REFERENCE_IMAGE_DIR];
    __block NSError *error = nil;
    return [recorder compareSnapshotOfViewOrLayer:viewOrLayer
                         referenceImagesDirectory:referenceImagesDirectory
                                       identifier:nil
                                            error:& error];
}
@end

EXPMatcherImplementationBegin(haveValidSnapshot, (NSString * snapshot)) {
    match(^BOOL{
        return [EXPExpect compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:NO];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected a matching snapshot in %@", snapshot];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: not to have a matching snapshot in %@", snapshot];
    });
}
EXPMatcherImplementationEnd

EXPMatcherImplementationBegin(recordSnapshot, (NSString * snapshot)) {
    match(^BOOL{
        return [EXPExpect compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:YES];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected to record a snapshot in %@", snapshot];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to record a matching snapshot in %@", snapshot];
    });
}
EXPMatcherImplementationEnd
