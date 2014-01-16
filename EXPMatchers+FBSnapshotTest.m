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
{
    FBTestSnapshotController *snapshotController = [[FBTestSnapshotController alloc] initWithTestClass:[testCase class]];
    FBSnapshotTestRecorder *recorder = [[FBSnapshotTestRecorder alloc] initWithController:snapshotController];
    recorder.selector = NSSelectorFromString(snapshot);
    recorder.recordMode = record;
    NSString * referenceImageDirectory = [[EXPExpectFBSnapshotTest instance] referenceImagesDirectory];
    if (! referenceImageDirectory) {
        [NSException raise:@"Missing value for referenceImageDirectory" format:@"Call [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory"];
    }
    __block NSError *error = nil;
    return [recorder compareSnapshotOfViewOrLayer:viewOrLayer
                         referenceImagesDirectory:referenceImageDirectory
                                       identifier:nil
                                            error:& error];
}

@end

void setReferenceImageDir(char *reference) {
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
    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:NO];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected a matching snapshot for test %@", sanitizedTestPath()];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: not to have a matching snapshot for test %@", sanitizedTestPath()];
    });
}
EXPMatcherImplementationEnd

EXPMatcherImplementationBegin(recordSnapshot, (void)) {

    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:YES];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected to record a snapshot for test %@", sanitizedTestPath()];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to record a matching snapshot test %@", sanitizedTestPath()];
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

    prerequisite(^BOOL{
        return !(snapshotIsNil);
    });

    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:NO];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected a matching snapshot in %@", snapshot];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: not to have a matching snapshot in %@", snapshot];
    });
}
EXPMatcherImplementationEnd

EXPMatcherImplementationBegin(recordSnapshotNamed, (NSString *snapshot)) {
    BOOL snapshotIsNil = (snapshot == nil);

    prerequisite(^BOOL{
        return !(snapshotIsNil);
    });

    match(^BOOL{
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:YES];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected to record a snapshot in %@", snapshot];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to record a matching snapshot in %@", snapshot];
    });
}
EXPMatcherImplementationEnd
