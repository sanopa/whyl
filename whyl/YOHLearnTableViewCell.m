//
//  YOHLearnTableViewCell.m
//  whyl
//
//  Created by Ruoxi Tan on 9/12/14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHLearnTableViewCell.h"

@implementation YOHLearnTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.addToHistoryButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        self.addToHistoryButton.frame = CGRectMake(8, 150/2-self.addToHistoryButton.frame.size.height/2, self.addToHistoryButton.frame.size.width, self.addToHistoryButton.frame.size.height);
        [self addSubview:self.addToHistoryButton];
        self.addToHistoryButton.hidden = YES;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 8, [UIScreen mainScreen].bounds.size.width - 8 - 30 - 8 - 8, 134)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
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
