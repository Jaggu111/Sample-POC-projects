//
//  ViewController.m
//  SampleBRTCrashTest
//
//  Created by Carl a Baltrunas on 4/24/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)testCrashButton:(id)sender {
}

- (IBAction)testButtonAction:(UIButton *)sender {
    NSLog(@"Warning: test app will crash");
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
         __builtin_trap();
    
    }];
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//     //   dispatch_async(dispatch_get_main_queue(), ^(void) {
//                __builtin_trap();
//     //   });
//    });
   
    // crash
}

- (IBAction)leaveButtonAction:(UIButton *)sender {
    dispatch_group_t locationGroup = dispatch_group_create();
    dispatch_group_enter(locationGroup);
    dispatch_group_leave(locationGroup);
    dispatch_group_leave(locationGroup);
    // and crash
}

- (IBAction)releaseButtonAction:(UIButton *)sender {
    NSArray *interfaces = (__bridge NSArray *)nil;
    CFRelease((__bridge CFArrayRef __nullable)interfaces);
    // and crash
}

- (IBAction)URLButtonAction:(UIButton *)sender {
    NSURL *library = [[NSFileManager.defaultManager
                       URLsForDirectory:NSCachesDirectory
                       inDomains:NSUserDomainMask]
                      firstObject];
    NSString *pathString = nil;
    NSURL *newURL = [library URLByAppendingPathComponent:pathString];
    // and crash
    NSLog(@"%@",newURL);
}

- (IBAction)indexButtonAction:(UIButton *)sender {
}

@end
