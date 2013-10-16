//
//  TodoItem.m
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/8/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "TodoItem.h"

@interface TodoItem ()

@property (nonatomic, strong) NSString * uuid;

@end


@implementation TodoItem

- (TodoItem *) initWithText: (NSString *) text {
    TodoItem * item = [[TodoItem alloc] init];

    item.text = text;
    item.uuid = [[NSUUID UUID] UUIDString];

    return item;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.text = [decoder decodeObjectForKey:@"text"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.text forKey:@"text"];
}

@end
