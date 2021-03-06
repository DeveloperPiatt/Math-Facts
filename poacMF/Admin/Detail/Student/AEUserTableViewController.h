//
//  AEUserTableViewController.h
//  poacMF
//
//  Created by Chris Vanderschuere on 05/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Course.h"

@interface AEUserTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) Student* studentToUpdate;
@property (nonatomic, strong) Course* courseToCreateIn;
@end
