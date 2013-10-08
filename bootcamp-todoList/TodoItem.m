//
//  TodoItem.m
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/8/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "TodoItem.h"

@interface TodoItem ()

@property (nonatomic, strong) NSString * itemText;
@property (nonatomic, strong) NSString * uuid;

@end


@implementation TodoItem

+ (TodoItem *) createItemWithText: (NSString *) text {
    TodoItem * item = [[TodoItem alloc] init];

    item.itemText = text;
    item.uuid = [[NSUUID UUID] UUIDString];

    return item;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.itemText = [decoder decodeObjectForKey:@"itemText"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.itemText forKey:@"itemText"];
}
@end
