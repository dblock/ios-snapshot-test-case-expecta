//
//  FBViewController.h
//  FBSnapshotTestCaseDemo
//
//  Created by Orta on 17/07/2014.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

@interface FBViewController : UIViewController

@property (nonatomic, assign) BOOL viewDidAppearCalled;
@property (nonatomic, assign) BOOL viewWillAppearCalled;

@end

@interface FBRedViewController : FBViewController
@end

@interface FBBlueViewController : FBViewController
@end