//
//  ItemListTableViewController.m
//  bootcamp-todoList
//
//  Created by Prashant Khanduri - Hearsay on 10/8/13.
//  Copyright (c) 2013 KDeal. All rights reserved.
//

#import "ItemListTableViewController.h"
#import "Constants.h"
#import "TodoItem.h"
#import "ItemTableCell.h"


@interface ItemListTableViewController ()

@property (nonatomic, strong) NSMutableArray * items;

@end

@implementation ItemListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    [self registerTapGesture];
    
    self.items = [[NSMutableArray alloc] init];
    [self loadItems];
}

/////////////////////////////////////////////////////////////////
///////////// UIGestureRecognizerDelegate
/////////////////////////////////////////////////////////////////

-(void) registerTapGesture{
    UITapGestureRecognizer * tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapDismiss.delegate = self;
    [self.tableView addGestureRecognizer:tapDismiss];
}

/////////////////////////////////////////////////////////////////
///////////// Helpers for saving / loading file
/////////////////////////////////////////////////////////////////

-(NSString *) pathForItemsPlist {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString * documents = [paths lastObject];
    return [documents stringByAppendingPathComponent:@"items.plist"];
}


-(void) loadItems {
    NSString * filePath = [self pathForItemsPlist];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

-(void)saveItems{
    NSString * filePath = [self pathForItemsPlist];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
}

/////////////////////////////////////////////////////////////////
///////////// Selectors
/////////////////////////////////////////////////////////////////

- (void)addItem:(id)sender {
    
    TodoItem * item = [[TodoItem alloc] initWithText:@""];
    [self.items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    
    [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
    
    [self saveItems];
}

-(void)dismissKeyboard {
    [self.tableView endEditing:YES];
}


/////////////////////////////////////////////////////////////////
///////////// UITableViewDataSource
/////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

/////////////////////////////////////////////////////////////////
///////////// UITableViewDelegate
/////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cCellIdentifier forIndexPath:indexPath];
    
    TodoItem * item = [self.items objectAtIndex:indexPath.row];
    
    cell.textField.text = item.text;
    cell.textField.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        ItemTableCell * insertedRow = (ItemTableCell * )[self.tableView cellForRowAtIndexPath:indexPath];
        [insertedRow.textField becomeFirstResponder];

    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    TodoItem * fromObject = [self.items objectAtIndex:fromIndexPath.row];
    TodoItem * toObject = [self.items objectAtIndex:toIndexPath.row];
    [self.items replaceObjectAtIndex:toIndexPath.row withObject:fromObject];
    [self.items replaceObjectAtIndex:fromIndexPath.row withObject:toObject];
    
    [self saveItems];
}

/////////////////////////////////////////////////////////////////
///////////// UITextFieldDelegate
/////////////////////////////////////////////////////////////////

- (void)textFieldDidEndEditing:(UITextView *)textView
{
    CGPoint hitPoint = [textView convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:hitPoint];
    self.items[index.row] = textView.text;
    
    [self saveItems];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [self saveItems];
    
    return YES;
}

@end
