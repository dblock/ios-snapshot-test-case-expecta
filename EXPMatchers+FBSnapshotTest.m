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

+ (NSString *)combinedError:(NSString *)message test:(NSString *)test error:(NSError *)error
{
    NSAssert(message, @"missing message");
    NSAssert(test, @"missing test name");

    NSMutableArray *ary = [NSMutableArray array];

    [ary addObject:[NSString stringWithFormat:@"%@ %@", message, test]];

    for(NSString *key in error.userInfo.keyEnumerator) {
        [ary addObject:[NSString stringWithFormat:@" %@: %@", key, [error.userInfo valueForKey:key]]];
    }
    
    return [ary componentsJoinedByString:@"\n"];
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
        return [EXPExpectFBSnapshotTest combinedError:@"expected a matching snapshot in" test:sanitizedTestPath() error:error];
    });

    failureMessageForNotTo(^NSString *{
        return [EXPExpectFBSnapshotTest combinedError:@"expected not to have a matching snapshot in" test:sanitizedTestPath() error:error];
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
            return [EXPExpectFBSnapshotTest combinedError:@"expected to record a snapshot in" test:sanitizedTestPath() error:error];
        } else {
            return [NSString stringWithFormat:@"snapshot %@ successfully recorded, replace recordSnapshot with a check", sanitizedTestPath()];
        }
    });

    failureMessageForNotTo(^NSString *{
        if (error) {
            return [EXPExpectFBSnapshotTest combinedError:@"expected to record a snapshot in" test:sanitizedTestPath() error:error];
        } else {
            return [NSString stringWithFormat:@"snapshot %@ successfully recorded, replace recordSnapshot with a check", sanitizedTestPath()];
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
        return @"you need Specta installed via CocoaPods to use haveValidSnapshot, use haveValidSnapshotNamed instead";
    });

    failureMessageForNotTo(^NSString *{
        return @"you need Specta installed via CocoaPods to use haveValidSnapshot, use haveValidSnapshotNamed instead";
    });
}
EXPMatcherImplementationEnd


EXPMatcherImplementationBegin(recordSnapshot, (void)) {

    prerequisite(^BOOL{
        return NO;
    });

    failureMessageForTo(^NSString *{
        return @"you need Specta installed via CocoaPods to use recordSnapshot, use recordSnapshotNamed instead";
    });

    failureMessageForNotTo(^NSString *{
        return @"you need Specta installed via CocoaPods to use recordSnapshot, use recordSnapshotNamed instead";
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
        return [EXPExpectFBSnapshotTest combinedError:@"expected a matching snapshot named" test:snapshot error:error];
    });

    failureMessageForNotTo(^NSString *{
        return [EXPExpectFBSnapshotTest combinedError:@"expected not to have a matching snapshot named" test:snapshot error:error];
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
            return [EXPExpectFBSnapshotTest combinedError:@"expected to record a matching snapshot named" test:snapshot error:error];
        } else {
            return [NSString stringWithFormat:@"snapshot %@ successfully recorded, replace recordSnapshot with a check", snapshot];
        }
    });

    failureMessageForNotTo(^NSString *{
        if (error) {
            return [EXPExpectFBSnapshotTest combinedError:@"expected to record a matching snapshot named" test:snapshot error:error];
        } else {
            return [NSString stringWithFormat:@"snapshot %@ successfully recorded, replace recordSnapshot with a check", snapshot];
        }
    });
}
EXPMatcherImplementationEnd
