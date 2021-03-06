//
//  TodoItem.h
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/8/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString * text;

- (TodoItem *) initWithText: (NSString *) text;

@end
