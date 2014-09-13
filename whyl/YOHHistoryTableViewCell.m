//
//  YOHHistoryTableViewCell.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHHistoryTableViewCell.h"

@implementation YOHHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.specialText = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, self.contentView.frame.size.width, 15.0)];
        self.specialText.font = [UIFont fontWithName:@"Kailasa" size:12.0];
        self.specialText.textColor = [UIColor lightGrayColor];
        self.specialText.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.specialText];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 50)];
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.numberOfLines = 0;
        self.title.font = [UIFont fontWithName:@"Kailasa-Bold" size:16.0];
        self.title.textColor = [UIColor colorWithRed:247/255.0 green:141/255.0 blue:3/255.0 alpha:1.0];
        [self.contentView addSubview:self.title];
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, self.contentView.frame.size.width - 20, 70)];
        self.description.lineBreakMode = NSLineBreakByTruncatingTail;
        self.description.numberOfLines = 0;
        self.description.font = [UIFont fontWithName:@"Kailasa" size:15.0];
        [self.contentView addSubview:self.description];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 80, 0, 70, 50)];
        self.date.lineBreakMode = NSLineBreakByWordWrapping;
        self.date.numberOfLines = 0;
        self.date.font = [UIFont fontWithName:@"Kailasa-Bold" size:16.0];
        self.date.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.date];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
