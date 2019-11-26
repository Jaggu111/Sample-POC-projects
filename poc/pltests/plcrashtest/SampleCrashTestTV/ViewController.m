//
//  ViewController.m
//  SampleBRTCrashTestTV
//
//  Created by Nallamothu Tharun Kumar on 8/9/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)testButtonAction:(id)sender {
    NSLog(@"Warning: test app will crash");
    __builtin_trap();
    // crash
}

@end
