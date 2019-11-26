//
//  ViewController.m
//  foo
//
//  Created by Carl a Baltrunas on 10/30/17.
//  Copyright © 2017 AT&T CDO. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "locationCell.h"
#import "visitCell.h"
#import "LC18.h"
#import "NSMutableData+PackageSerializer.h"

@interface ViewController ()

@property (strong, nonatomic) LC18 *lc18;
@property (strong, nonatomic) NSDateFormatter *DateFormatter;
@property (assign, nonatomic) BOOL gpsState;
@property (assign, nonatomic) BOOL visitState;
@property (atomic) BOOL observersSetup;
@property (atomic) UIApplicationState applicationState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableData = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _lc18 = [[LC18 alloc] init];
    [_tableView reloadData];
    _DateFormatter = [[NSDateFormatter alloc] init];
    _DateFormatter.dateFormat = @"hh:mm:ss";
    _gpsState = NO;
    _visitState = NO;
    [self gpsButtonAction:_gpsButton]; // turn it on
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupEventObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)whereAmIButtonAction:(UIButton *)sender {
    [sender setTitle: @"Think.i.n.g..." forState:UIControlStateSelected];
    [sender setTitle: @"Think.i.n.g..." forState:UIControlStateDisabled];
    [sender setTitle: @"Think.i.n.g..." forState:UIControlStateHighlighted];
    CLLocation *loc = _lc18.myLocation;
    if (loc) {
        [_tableData insertObject:loc atIndex:0];
    }
    [_tableView reloadData];
}

- (IBAction)clearButtonAction:(id)sender {
    [_tableData removeAllObjects];
    [_tableView reloadData];
}

- (void)setGPSButtonTitle:(UIButton *)button {
    [button setTitle:_gpsState ? @"On" : @"Off" forState:UIControlStateNormal];
    [button setTitle:_gpsState ? @"On" : @"Off" forState:UIControlStateSelected];
    [button setTitle:_gpsState ? @"On" : @"Off" forState:UIControlStateDisabled];
}

- (IBAction)gpsButtonAction:(UIButton *)sender {
    _gpsState = !_gpsState;
    [self setGPSButtonTitle:sender];
    [_lc18 setGPSPolling:_gpsState];
}

- (IBAction)visitButtonAction:(UIButton *)sender {
    _visitState = !_visitState;
    [self setVisitButtonTitle:sender];
    if (_visitState) {
        [_lc18 enableVisitsWithCompletion:^(CLVisit *visit) {
            if (visit) {
                [_tableData insertObject:visit atIndex:0];
                [_tableView reloadData];
            }
        }];
    }
    else {
        [_lc18 disableVisits];
    }
}

- (IBAction)fakeVisitButtonAction:(UIButton *)sender {
    CLVisit *visit = [[CLVisit alloc] init];


    [[NSNotificationCenter defaultCenter] postNotificationName:@"FakeVisit" object:nil userInfo:@{@"Visit": visit}];
}

- (void)setVisitButtonTitle:(UIButton *)button {
    [button setTitle:_visitState ? @"Disable" : @"Enable" forState:UIControlStateNormal];
    [button setTitle:_visitState ? @"Disable" : @"Enable" forState:UIControlStateSelected];
    [button setTitle:_visitState ? @"Disable" : @"Enable" forState:UIControlStateDisabled];
}


#pragma mark - tableview delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *locationTableIdentifier = @"locationItem";
    static NSString *visitTableIdentifier = @"visitItem";
    static NSString *emptyTableIdentifier = @"emptyItem";

    uint64_t row = indexPath.row;
    UIColor *color;
    if (row & 1) {  // alternate color bars on tableview
        color = [UIColor colorWithRed:0.0f green:255/255.0f blue:255/255.0f alpha:0.50f];
    }
    else {
        color = [UIColor colorWithRed:0.0f green:255/255.0f blue:255/255.0f alpha:0.25f];
    }

    id object = _tableData[row];
    if ([object isKindOfClass:[CLLocation class]]) {
        locationCell *cell = [tableView dequeueReusableCellWithIdentifier:locationTableIdentifier];
        cell.backgroundColor = color;

        CLLocation *location = _tableData[row];
        if (_tableData.count > (row + 1)) {
            cell.duplicateLabel.text = (location == _tableData[row + 1]) ? @"*Dup*" : @" ";
        }
        else {
            cell.duplicateLabel.text = @" ";
        }
        cell.timeLabel.text = [_DateFormatter stringFromDate:location.timestamp];
        cell.coordinateLabel.text = [NSString stringWithFormat:@"Location: %.8f,%-.8f", location.coordinate.latitude, location.coordinate.longitude];
        cell.altitudeLabel.text = [NSString stringWithFormat:@"Altitude: %6.2fm", location.altitude];
        if (location.speed < 0) {
            cell.speedLabel.text = @"Speed: None";
        }
        else {
            cell.speedLabel.text = [NSString stringWithFormat:@"Speed: %6.2fm/s", location.speed];
        }
        if (location.course < 0) {
            cell.courseLabel.text = @"Course: None";
        }
        else {
            cell.courseLabel.text = [NSString stringWithFormat:@"Course: %6.2f°", location.course];
        }
        cell.horizontalAccuracyLabel.text = [NSString stringWithFormat:@"H-Acc: %6.2fm", location.horizontalAccuracy];
        cell.verticalAccuracyLabel.text = [NSString stringWithFormat:@"V-Acc: %6.2fm", location.verticalAccuracy];

        return cell;
    }
    else if ([object isKindOfClass:[CLVisit class]]) {
        visitCell *cell = [tableView dequeueReusableCellWithIdentifier:visitTableIdentifier];
        cell.backgroundColor = color;

        CLVisit *visit = _tableData[row];
        if (_tableData.count > (row + 1)) {
            cell.duplicateLabel.text = (visit == _tableData[row + 1]) ? @"*Dup*" : @" ";
        }
        else {
            cell.duplicateLabel.text = @" ";
        }
        cell.arriveLabel.text = [_DateFormatter stringFromDate:visit.arrivalDate];
        cell.departLabel.text = [_DateFormatter stringFromDate:visit.arrivalDate];
        cell.coordinateLabel.text = [NSString stringWithFormat:@"Location: %.8f,%-.8f", visit.coordinate.latitude, visit.coordinate.longitude];

        cell.horizontalAccuracyLabel.text = [NSString stringWithFormat:@"H-Acc: %6.2fm", visit.horizontalAccuracy];

        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:emptyTableIdentifier];
        return cell;
    }
}


#pragma mark - Observers

static NSNotificationName JustVisiting = @"JustVisiting";

/*!
 *  @method setupEventObservers
 *  @abstract   template for methods which use action_queue
 *              convenience for cutting and pasting new threaded code
 *
 */
- (void)setupEventObservers {
    // ensure that there are no previously setup observers
    [self removeEventObservers];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(justVisiting:)
     name:JustVisiting
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(enterForeground:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(enteredBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(willResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(willTerminate:)
     name:UIApplicationWillTerminateNotification
     object:nil];

    // track the status of notification observers enabled
    self.observersSetup = YES;
}

- (void)justVisiting:(NSNotification *)notification {
    CLVisit *visit = notification.userInfo[@"Visit"];
    if (visit) {
        [_tableData insertObject:visit atIndex:0];
        [_tableView reloadData];
    }
}



/*!
 *  @method enterForeground
 *  @abstract   perform anything we need to do
 *              when entering the foreground
 *              this method is called when initially starting
 *              and when re-entering the foreground from the background
 *
 */
- (void)enterForeground:(NSNotification *)notification {
    // check for any package uploads on app start, or return to foreground
    self.applicationState = [UIApplication sharedApplication].applicationState;
}

- (void)enteredBackground:(NSNotification *)notification {
    self.applicationState = [UIApplication sharedApplication].applicationState;
}

/*!
 *  @method willResignActive
 *  @abstract   perform anything we want to do before entering the background
 *              such as queuing any waiting packages for upload
 *
 */
- (void)willResignActive:(NSNotification *)notification {
    // time to do (background) package uploading before entering the background
    self.applicationState = [UIApplication sharedApplication].applicationState;
}

/*!
 *  @method willTerminate
 *  @abstract   perform any actions desired when going into background
 *              in particular, check for performing batched uploads
 *
 */
- (void)willTerminate:(NSNotification *)notification {
    // time to do (background) package uploading, before app terminates
    // completions may not occur until after app termination, and may be re-tried
    self.applicationState = [UIApplication sharedApplication].applicationState;

    // upon will termination disable monitoring visits
    [self.lc18 disableVisits];
    [self.lc18 setGPSPolling:NO];
}


/*!
 *  @method removeEventObservers
 *  @abstract   template for methods which use action_queue
 *              convenience for cutting and pasting new threaded code
 *
 */
- (void)removeEventObservers {
    // track these are disabled
    self.observersSetup = NO;

    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationWillResignActiveNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIApplicationWillTerminateNotification
     object:nil];
}




@end
