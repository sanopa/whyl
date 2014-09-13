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
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 50)];
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.numberOfLines = 0;
        [self.contentView addSubview:self.title];
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, [UIScreen mainScreen].bounds.size.width, 70)];
        self.description.lineBreakMode = NSLineBreakByWordWrapping;
        self.description.numberOfLines = 0;
        [self.contentView addSubview:self.description];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 50)];
        self.date.lineBreakMode = NSLineBreakByWordWrapping;
        self.date.numberOfLines = 0;
        [self.contentView addSubview:self.date];
        
        self.specialText = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.contentView.frame.size.width, 15)];
        self.specialText.font = [UIFont fontWithName:@"Arial" size:14.0];
        [self.contentView addSubview:self.specialText];
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
