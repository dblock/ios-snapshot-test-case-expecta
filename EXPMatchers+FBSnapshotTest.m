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


+ (BOOL)compareSnapshotOfViewOrLayer:(id)viewOrLayer snapshot:(NSString *)snapshot testCase:(id)testCase record:(BOOL)record referenceDirectory:(NSString *)referenceDirectory
{
    FBSnapshotTestController *snapshotController = [[FBSnapshotTestController alloc] initWithTestClass:[testCase class]];
    snapshotController.recordMode = record;
    snapshotController.referenceImagesDirectory = referenceDirectory;
    
    if (! snapshotController.referenceImagesDirectory) {
        [NSException raise:@"Missing value for referenceImagesDirectory" format:@"Call [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory"];
    }
    __block NSError *error = nil;
    return [snapshotController compareSnapshotOfViewOrLayer:viewOrLayer
                                                   selector:NSSelectorFromString(snapshot)
                                                 identifier:nil
                                                      error:& error];
}

@end

void setGlobalReferenceImageDir(char *reference) {
    NSString *referenceImagesDirectory = [NSString stringWithFormat:@"%s", reference];
    [[EXPExpectFBSnapshotTest instance] setReferenceImagesDirectory:referenceImagesDirectory];
};

@interface EXPExpect(ReferenceDirExtension)
- (NSString *)_getDefaultReferenceDirectory;
@end

@implementation EXPExpect(ReferenceDirExtension)

- (NSString *)_getDefaultReferenceDirectory
{
    NSString *globalReference = [[EXPExpectFBSnapshotTest instance] referenceImagesDirectory];
    if (globalReference) {
        return globalReference;
    }
    
    // Search the test file's path to find the first folder with the substring "tests"
    // then append "/ReferenceImages" and use that
    
    NSString *testFileName = [NSString stringWithCString:self.fileName encoding:NSUTF8StringEncoding];
    NSArray *pathComponents = [testFileName pathComponents];
    
    for (NSString *folder in pathComponents) {
        if ([folder.lowercaseString rangeOfString:@"tests"].location != NSNotFound) {
            
            NSArray *folderPathComponents = [pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents indexOfObject:folder] + 1)];
            return [NSString stringWithFormat:@"%@/ReferenceImages", [folderPathComponents componentsJoinedByString:@"/"]];
            
        }
    }
    
    [NSException raise:@"Could not infer reference image folder" format:@"You should provide a reference dir using setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);"];
    return nil;
}
@end



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
        NSString *referenceImageDir = [self _getDefaultReferenceDirectory];
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:NO referenceDirectory:referenceImageDir];
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
        NSString *referenceImageDir = [self _getDefaultReferenceDirectory];
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:sanitizedTestPath() testCase:[self testCase] record:YES referenceDirectory:referenceImageDir];
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
        NSString *referenceImageDir = [self _getDefaultReferenceDirectory];
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:NO referenceDirectory:referenceImageDir];
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
        NSString *referenceImageDir = [self _getDefaultReferenceDirectory];
        return [EXPExpectFBSnapshotTest compareSnapshotOfViewOrLayer:actual snapshot:snapshot testCase:[self testCase] record:YES referenceDirectory:referenceImageDir];
    });
    
    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected to record a snapshot in %@", snapshot];
    });
    
    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to record a matching snapshot in %@", snapshot];
    });
}
EXPMatcherImplementationEnd
