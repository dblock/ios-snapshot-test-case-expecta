//
//  FBViewController.m
//  FBSnapshotTestCaseDemo
//
//  Created by Orta on 17/07/2014.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBViewController.h"

@interface FBViewController ()

@end

@implementation FBViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewDidAppearCalled = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewWillAppearCalled = YES;
}

@end
