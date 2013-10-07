//
//  DetailViewController.h
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/7/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
