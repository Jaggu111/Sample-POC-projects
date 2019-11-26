//
//  ViewController.h
//  foo
//
//  Created by Carl a Baltrunas on 10/30/17.
//  Copyright © 2017 AT&T CDO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *whereAmIButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *tableData;

@end

