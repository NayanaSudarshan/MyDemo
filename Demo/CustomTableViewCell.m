//
//  CustomTableViewCell.m
//  Demo
//
//  Created by Satish on 13/01/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "CustomTableViewCell.h"
#define FONT_SIZE 15.0
#define COORDINATE_VALUE 10

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.cellImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(COORDINATE_VALUE, COORDINATE_VALUE, 80, 80)]autorelease];
        self.self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.self.descriptionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        [self.cellImageView setTag:3];
        [self.contentView addSubview:self.cellImageView];
        
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
        [self.titleLabel setTag:0];
        [self.contentView addSubview:self.titleLabel];
        
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE];
        [self.descriptionLabel setTag:1];
        [self.contentView addSubview:self.descriptionLabel];
    }
    
    return self;
}

@end
