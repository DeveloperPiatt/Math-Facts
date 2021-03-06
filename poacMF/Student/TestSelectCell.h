//
//  TestSelectCell.h
//  poacMF
//
//  Created by Chris Vanderschuere on 15/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "AQGridViewCell.h"

//Cell for grid of avalible tests
@interface TestSelectCell : AQGridViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL locked;
@property (nonatomic, strong) NSNumber* passedLevel; //0: not passed 1: passed 2: passed+10% 3: passed+20%



@end
