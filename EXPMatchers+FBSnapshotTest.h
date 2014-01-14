//
//  EXPMatchers+FBSnapshotTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "Expecta.h"

#ifndef FB_REFERENCE_IMAGE_DIR
#error FB_REFERENCE_IMAGE_DIR is not defined. Define it in GCC_PREPROCESSOR_DEFINITIONS to point to a directory.
#endif

EXPMatcherInterface(haveValidSnapshot, (NSString * snapshot));
EXPMatcherInterface(recordSnapshot, (NSString * snapshot));
