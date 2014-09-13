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
        self.addToHistoryButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 8 - 30, 8, 30, 30)];
        [self addSubview:self.addToHistoryButton];
        self.addToHistoryButton.hidden = YES;
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width - 8 - 30 - 8 - 8, 30)];
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
