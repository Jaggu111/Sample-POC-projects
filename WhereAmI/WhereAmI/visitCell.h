//
//  visitCell.h
//  foo
//
//  Created by Carl a Baltrunas on 11/8/17.
//  Copyright © 2017 AT&T CDO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface visitCell : UITableViewCell

// latitude, longitude, altitude
@property (weak, nonatomic) IBOutlet UILabel* coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *arriveLabel;
@property (weak, nonatomic) IBOutlet UILabel *departLabel;
@property (weak, nonatomic) IBOutlet UILabel *duplicateLabel;

// accuracy
@property (weak, nonatomic) IBOutlet UILabel* horizontalAccuracyLabel;

@end
