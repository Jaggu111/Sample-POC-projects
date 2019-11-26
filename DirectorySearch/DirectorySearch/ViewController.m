//
//  ViewController.m
//  DirectorySearch
//
//  Created by Carl a Baltrunas on 3/22/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "ViewController.h"
#import "ScanDirectory.h"
#import "Util.h"


@interface ViewController ()


@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Nothing to view, just prointing out directory info
    [ScanDirectory showTopLevelDirectories];
    [ScanDirectory showSubDirectories];
    sleep(10);
//    NSURL *URL = Util.libraryDirectoryURL;
//    NSURL *crash = [URL URLByAppendingPathComponent:nil];
}



@end

