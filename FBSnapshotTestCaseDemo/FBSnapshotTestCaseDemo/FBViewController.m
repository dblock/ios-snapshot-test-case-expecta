//
//  FBViewController.m
//  FBSnapshotTestCaseDemo
//
//  Created by Orta on 17/07/2014.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBViewController.h"
#import "FBExampleView.h"

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewDidAppearCalled = YES;
    self.viewDidAppearCalledCount++;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewWillAppearCalled = YES;
    self.viewWillAppearCalledCount++;
}

@end

@implementation FBBlueViewController

- (void)loadView
{
    self.view = [[FBBlueView alloc] init];
}

@end

@implementation FBRedViewController

- (void)loadView
{
    self.view = [[FBRedView alloc] init];
}

@end
