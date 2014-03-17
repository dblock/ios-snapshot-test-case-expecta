//
//  EXPMatchers+FBSnapshotTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "EXPMatchers+FBSnapshotTest.h"
#import "EXPMatcherHelpers.h"
#import "FBSnapshotTestController.h"

@interface EXPExpectFBSnapshotTest()
@property (nonatomic, strong) NSString *referenceImagesDirectory;
@end

@implementation EXPExpectFBSnapshotTest

+ (id)instance
{
    static EXPExpectFBSnapshotTest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (BOOL)compareSnapshotOfViewOrLayer:(id)viewOrLayer
                           snapshot:(NSString *)snapshot
                           testCase:(id)testCase
                             record:(BOOL)record
                               error:(NSError **)error
{
    FBSnapshotTestController *snapshotController = [[FBSnapshotTestController alloc] initWithTestClass:[testCase class]];
    snapshotController.recordMode = record;
    snapshotController.referenceImagesDirectory = [[EXPExpectFBSnapshotTest instance] referenceImagesDirectory];
    if (! snapshotController.referenceImagesDirectory) {
        [NSException raise:@"Missing value for referenceImagesDirectory" format:@"Call [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory"];
    }
    return [snapshotController compareSnapshotOfViewOrLayer:viewOrLayer
                                                   selector:NSSelectorFromString(snapshot)
                                                 identifier:nil
                                                      error:error];
}

@end

void setGlobalReferenceImageDir(char *reference) {
    NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%s", reference];
    [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory:referenceImagesDirectory];
};

// If you're bringing in Speca via CocoaPods
// use the test path to get the test's image file URL

#ifdef COCOAPODS_POD_AVAILABLE_Specta
#import "Specta.h"
#import "SpectaUtility.h"
#import "SPTExample.h"

NSString *sanitizedTestPath();

NSString *sanitizedTestPath(){
    SPTXCTestCase *test = [[NSThread currentThread] threadDictionary][SPTCurrentTestCaseKey];

    NSString *specName = NSStringFromClass([test class]);
    SPTExample *compiledExample = [test spt_getCurrentExample];
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
    NSString *currentTestName = [[compiledExample.name componentsSeparatedByCharactersInSet:[charSet invertedSet]] componentsJoinedByString:@"_"];

    return [NSString stringWithFormat:@"%@/%@", specName, currentTestName];
}

EXPMatcherImplementationBegin(haveValidSnapshot, (void)){
    __block NSError *error = nil;
    
    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:NO error:&error];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected a matching snapshot for test %@\n  path=%@\n  error=%@\n  reason=%@",
                sanitizedTestPath(), [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: not to have a matching snapshot for test %@\n  path=%@\n  error=%@\n  reason=%@",
                sanitizedTestPath(), [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
    });
}
EXPMatcherImplementationEnd

EXPMatcherImplementationBegin(recordSnapshot, (void)) {
    __block NSError *error = nil;

    match(^BOOL{
        [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:YES error:&error];
        return NO;
    });

    failureMessageForTo(^NSString *{
        if (error) {
            return [NSString stringWithFormat:@"expected to record a snapshot for test %@\n  path=%@\n  error=%@\n  reason=%@",
                    sanitizedTestPath(), [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
        } else {
            return [NSString stringWithFormat:@"snapshot successfully recorded for %@, replace recordSnapshot with a check", sanitizedTestPath()];
        }
    });

    failureMessageForNotTo(^NSString *{
        if (error) {
            return [NSString stringWithFormat:@"expected: to record a matching snapshot test %@\n  path=%@\n  error=%@\n  reason=%@",
                    sanitizedTestPath(), [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
        } else {
            return [NSString stringWithFormat:@"snapshot successfully recorded for %@, replace recordSnapshot with a check", sanitizedTestPath()];
        }
    });
}
EXPMatcherImplementationEnd

#else

// If you don't have Speca stub the functions

EXPMatcherImplementationBegin(haveValidSnapshot, (void)){
    prerequisite(^BOOL{
        return NO;
    });

    failureMessageForTo(^NSString *{
        return @"You need Specta installed via CocoaPods to use haveValidSnapshot, use haveValidSnapshotNamed instead";
    });

    failureMessageForNotTo(^NSString *{
        return @"You need Specta installed via CocoaPods to use haveValidSnapshot, use haveValidSnapshotNamed instead";
    });
}
EXPMatcherImplementationEnd


EXPMatcherImplementationBegin(recordSnapshot, (void)) {

    prerequisite(^BOOL{
        return NO;
    });

    failureMessageForTo(^NSString *{
        return @"You need Specta installed via CocoaPods to use recordSnapshot, use recordSnapshotNamed instead";
    });

    failureMessageForNotTo(^NSString *{
        return @"You need Specta installed via CocoaPods to use recordSnapshot, use recordSnapshotNamed instead";
    });
}
EXPMatcherImplementationEnd


#endif



EXPMatcherImplementationBegin(haveValidSnapshotNamed, (NSString *snapshot)){
    BOOL snapshotIsNil = (snapshot == nil);
    __block NSError *error = nil;

    prerequisite(^BOOL{
        return !(snapshotIsNil);
    });

    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:NO error:&error];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected a matching snapshot for %@\n  path=%@\n  error=%@\n  reason=%@",
                snapshot, [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: not to have a matching snapshot for %@\n  path=%@\n  error=%@\n  reason=%@",
                snapshot, [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
    });
}
EXPMatcherImplementationEnd

EXPMatcherImplementationBegin(recordSnapshotNamed, (NSString *snapshot)) {
    BOOL snapshotIsNil = (snapshot == nil);
    __block NSError *error = nil;

    prerequisite(^BOOL{
        return !(snapshotIsNil);
    });

    match(^BOOL{
        [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:YES error:&error];
        return NO;
    });

    failureMessageForTo(^NSString *{
        if (error) {
            return [NSString stringWithFormat:@"expected to record a snapshot for %@\n  path=%@\n  error=%@\n  reason=%@",
                    snapshot, [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
        } else {
            return [NSString stringWithFormat:@"snapshot successfully recorded for %@, replace recordSnapshot with a check", snapshot];
        }
    });

    failureMessageForNotTo(^NSString *{
        if (error) {
            return [NSString stringWithFormat:@"expected: to record a matching snapshot for %@\n  path=%@\n  error=%@\n  reason=%@",
                    snapshot, [error.userInfo valueForKey:FBReferenceImageFilePathKey], error.localizedDescription, error.localizedFailureReason];
        } else {
            return [NSString stringWithFormat:@"snapshot successfully recorded for %@, replace recordSnapshot with a check", snapshot];
        }
    });
}
EXPMatcherImplementationEnd
