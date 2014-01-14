//
//  EXPMatchers+FBSnapshotTest.h
//  Artsy
//
//  Created by Daniel Doubrovkine on 1/14/14.
//  Copyright (c) 2014 Artsy Inc. All rights reserved.
//

#import "Expecta.h"

EXPMatcherInterface(haveValidSnapshot, (NSString * snapshot));
EXPMatcherInterface(recordSnapshot, (NSString * snapshot));
