//
//  ItemTableCell.m
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/11/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "ItemTableCell.h"

@implementation ItemTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
