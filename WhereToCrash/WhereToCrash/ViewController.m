//
//  ViewController.m
//  WhereToCrash
//
//  Created by Carl a Baltrunas on 3/3/19.
//  Copyright © 2019 AT&T CDO. All rights reserved.
//

#import "ViewController.h"
#import "BRTLocationInformation.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *DoNothingButton;

@end

@implementation ViewController

static CLLocationManager *locationManager = nil;
static dispatch_queue_t queue = nil;
static NSMutableArray *list = nil;
static dispatch_group_t group = nil;
static dispatch_time_t waitTime = 0;
static int64_t inblock = 0;

#define EXERCISE_COUNT      64
#define SLEEP_TIME          5
#define WAIT_TIME           90

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // create a location manager
    locationManager = [[CLLocationManager alloc] init];
    [BRTLocationInformation setLocationManager:locationManager];

//    // prime the pump for getting locations
//    [locationManager requestLocation];


    queue = dispatch_queue_create("com.att.mobile.bdsdk.metrics", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0));
    group = dispatch_group_create();
    waitTime = dispatch_time(DISPATCH_TIME_NOW, WAIT_TIME * NSEC_PER_SEC);

    [BRTLocationInformation currentLocationData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // get authorization
    [locationManager requestWhenInUseAuthorization];

    // sleep a little to let the location gathering get started
    sleep (SLEEP_TIME);

    list = [[NSMutableArray alloc] initWithCapacity:EXERCISE_COUNT];
}

- (IBAction)DoNothingButtonAction:(id)sender {
    NSLog(@"Exercise the location gathering threads");

    // prime the pump for getting locations
    [locationManager requestLocation];

    // exercise the demons
    [self exerciseLocation];
}


- (void)exerciseLocation {
    @autoreleasepool {

        myprintf("|");
        for (int i=0; i < EXERCISE_COUNT; i++) {
            //            dispatch_group_async(group, queue, ^{
            inblock++;
            myprintf("<");
            dispatch_async(queue, ^{
                NSData *data = [BRTLocationInformation currentLocationData];
                [list addObject:data];
                myprintf(">");
                inblock--;
            });
        }
        myprintf("{");
        int8_t loop = WAIT_TIME;
        while (inblock > 0) {
            sleep(1);
            if (loop-- < 0) {
                myprintf(" -- timeout -(in:%lld %d)-\n", inblock, loop);
                break;
            }
        }
        myprintf("}");
        [list removeAllObjects];
    }
}


@end
