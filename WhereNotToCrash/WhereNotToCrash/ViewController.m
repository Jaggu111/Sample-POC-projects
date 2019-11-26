//
//  ViewController.m
//  WhereNotToCrash
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

#define EXERCISE_COUNT      10
#define SLEEP_TIME          5
#define WAIT_TIME           30

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // create a location manager
    locationManager = [[CLLocationManager alloc] init];
    [BRTLocationInformation setLocationManager:locationManager];

    // prime the pump for getting locations
    [locationManager requestLocation];


    queue = dispatch_queue_create("com.att.mobile.bdsdk.metrics", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0));
    group = dispatch_group_create();
    waitTime = dispatch_time(DISPATCH_TIME_NOW, WAIT_TIME * NSEC_PER_SEC);
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
    if (![NSThread isMainThread]) {
        printf("%s not main thread\n",__FUNCTION__);
    }
    [locationManager requestLocation];

    // exercise the demons
    while (1) {
        [self exerciseLocation];
    }
}


- (void)exerciseLocation {
    @autoreleasepool {

        myprintf("|");
        if (!locationManager.delegate) {
            printf(" #NODelagate# ");
        }
        for (int i=0; i < EXERCISE_COUNT; i++) {
            inblock++;
            myprintf("<");
//            dispatch_async(queue, ^{
            dispatch_group_async(group, queue, ^{
                NSData * data = [BRTLocationInformation currentLocationData];
                NSData * foo = data;
                myprintf(">");
                inblock--;
            });
        }
        myprintf("{");
        int64_t timeout = dispatch_group_wait(group,
                            dispatch_time(DISPATCH_TIME_NOW, WAIT_TIME * NSEC_PER_SEC));
        if (timeout) {
            myprintf(" -- timeout %lld -\n", inblock);

        }
        myprintf("}");
    }
}

- (void)exerciseLocation1 {
    @autoreleasepool {

        myprintf("|");
        for (int i=0; i < EXERCISE_COUNT; i++) {
            inblock++;
            myprintf("<");
            dispatch_async(queue, ^{
                NSData * data = [BRTLocationInformation currentLocationData];
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
    }
}


@end
