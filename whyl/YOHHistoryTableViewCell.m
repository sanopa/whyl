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
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 25)];
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.numberOfLines = 0;
        [self.contentView addSubview:self.title];
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 70)];
        self.description.lineBreakMode = NSLineBreakByWordWrapping;
        self.description.numberOfLines = 0;
        [self.contentView addSubview:self.description];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 100, 30)];
        self.date.lineBreakMode = NSLineBreakByWordWrapping;
        self.date.numberOfLines = 0;
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
