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
    
    //self.items = [[NSMutableArray alloc] init];
    [self loadItems];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    [self registerTapGesture];
    
}

/////////////////////////////////////////////////////////////////
///////////// UIGestureRecognizerDelegate
/////////////////////////////////////////////////////////////////

-(void) registerTapGesture {
    
    UITapGestureRecognizer * tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapDismiss.delegate = self;
    
    [self.tableView addGestureRecognizer:tapDismiss];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (self.tableView.isEditing) {
        return NO;
    }
    return YES;
}

/////////////////////////////////////////////////////////////////
///////////// Helpers for saving / loading file
/////////////////////////////////////////////////////////////////

//-(NSString *) pathForItemsPlist {
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
//    NSString * documents = [paths lastObject];
//    return [documents stringByAppendingPathComponent:@"items.plist"];
//}


-(void) loadItems {
//    NSString * filePath = [self pathForItemsPlist];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    } else {
//        self.items = [[NSMutableArray alloc] init];
//    }
    NSData *serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"items"];
    self.items = [NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    if (nil == self.items){
        self.items = [[NSMutableArray alloc] init];
    }
}

-(void)saveItems{
    NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:self.items];
    [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:@"items"];
    
//    NSString * filePath = [self pathForItemsPlist];
//    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
}

/////////////////////////////////////////////////////////////////
///////////// Selectors
/////////////////////////////////////////////////////////////////

- (void)addItem:(id)sender {
    
    TodoItem * item = [[TodoItem alloc] initWithText:@""];
    [self.items insertObject:item atIndex:0];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

/////////////////////////////////////////////////////////////////
///////////// UITableViewDelegate
/////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cCellIdentifier forIndexPath:indexPath];
    
    TodoItem * item = [self.items objectAtIndex:indexPath.row];
    
    cell.textField.delegate = self;
    cell.textField.text = item.text;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveItems];
    
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        ItemTableCell * insertedRow = (ItemTableCell * )[self.tableView cellForRowAtIndexPath:indexPath];
        [insertedRow.textField becomeFirstResponder];

    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    
    TodoItem * fromObject = [self.items objectAtIndex:fromIndexPath.row];
    TodoItem * toObject = [self.items objectAtIndex:toIndexPath.row];
    
    [self.items replaceObjectAtIndex:toIndexPath.row withObject:fromObject];
    [self.items replaceObjectAtIndex:fromIndexPath.row withObject:toObject];
    
    [self saveItems];
}

/////////////////////////////////////////////////////////////////
///////////// UITextFieldDelegate
/////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.tableView.isEditing) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGPoint point = [textField convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    TodoItem * item = (TodoItem *)[self.items objectAtIndex:indexPath.row];
    item.text = textField.text;
    
    [self saveItems];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self saveItems];
    
    return YES;
}

@end
