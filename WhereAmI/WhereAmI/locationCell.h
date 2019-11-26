//
//  locationCell.h
//  foo
//
//  Created by Carl a Baltrunas on 11/8/17.
//  Copyright © 2017 AT&T CDO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface locationCell : UITableViewCell

// latitude, longitude, altitude
@property (weak, nonatomic) IBOutlet UILabel* coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel* altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *duplicateLabel;

// horizontal speed, vertical speed, course
@property (weak, nonatomic) IBOutlet UILabel* speedLabel;
@property (weak, nonatomic) IBOutlet UILabel* courseLabel;

// accuracy
@property (weak, nonatomic) IBOutlet UILabel* horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel* verticalAccuracyLabel;


@end
