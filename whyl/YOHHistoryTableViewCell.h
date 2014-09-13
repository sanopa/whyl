//
//  YOHHistoryTableViewCell.h
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOHHistoryTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *description;
@property (nonatomic, strong) NSDate *dateSaved;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) UIImage *image;
@end
